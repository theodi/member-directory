# encoding: utf-8
require 'spec_helper'

describe Member do

  let(:member) do
    FactoryGirl.create(:member)
  end

  it "creates an embed stat" do
    member.register_embed("http://www.example.com/page")

    stat = member.embed_stats.first

    expect(stat.referrer).to eq("http://www.example.com/page")
    expect(stat.member).to eq(member)
  end

  it "only creates one embed stat per referrer" do
    2.times do
      member.register_embed("http://www.example.com/page")
    end

    expect(member.embed_stats.count).to eq(1)
  end

  context "creating a member" do
    %w[organization_name organization_size organization_type organization_sector].each do |name|
      it "requires an organisation name" do
        (member = Member.new).valid?
        expect(member.errors[name.to_sym]).to include("can't be blank")
      end
    end

    it "requires organization_size to be in options" do
      (member = Member.new).valid?
      expect(member.errors[:organization_size]).to include("is not included in the list")
      %w[<10 10-50 51-250 251-1000 >1000].each do |option|
        member.organization_size = option
        member.valid?
        expect(member.errors[:organization_size]).to_not include("is not included in the list")
      end
    end

    it "fails if organization already exists" do
      FactoryGirl.create(:organization, :name => "Acme")
      (member = Member.new(:organization_name => "Acme")).valid?
      expect(member.errors[:organization_name]).to include("is already taken")
    end

    it 'strips spaces from organization name' do
      member = FactoryGirl.create(:member, :organization_name => '  Acme  ')
      expect(member.organization_name).to eq("Acme")
      expect(member.organization.name).to eq("Acme")
    end

    it "does not need organization details for an individual" do
      member = Member.new(product_name: 'individual')
      organization_errors = member.errors.select {|k,_| k.to_s.starts_with?('organization_') }
      expect(organization_errors).to be_empty
    end
  end

  context "updating a member" do
    it "does not run validations on organization" do
      member = FactoryGirl.create(:member)
      # this is required on upate but not set up by factories
      member.organization.description = Faker::Company.catch_phrase
      member.organization_size = nil
      member.organization_sector = nil
      member.organization_name = nil
      member.organization_type = nil
      member.valid?
      expect(member.errors).to be_empty
    end
  end

  context 'setting up chargify links' do
    before do
      Member::CHARGIFY_PRODUCT_LINKS.clear
      Member::CHARGIFY_PRODUCT_PRICES.clear
      Member::CHARGIFY_COUPON_DISCOUNTS.clear
      allow(Chargify::Coupon).to receive(:all).and_return([])
    end

    it 'assigns the api handle and first public signup page' do
      product = double('product')
      page = double('page')
      allow(page).to receive(:url).and_return("http://i.am/an/url")
      allow(product).to receive(:price_in_cents)
      allow(product).to receive(:product_family).and_return(double('pf', id: 1))
      allow(product).to receive(:handle).and_return("plan_name")
      allow(product).to receive(:public_signup_pages).and_return([page])
      expect(Chargify::Product).to receive(:all).and_return([product])
      Member.initialize_chargify_links!
      expect(Member::CHARGIFY_PRODUCT_LINKS["plan_name"]).to eq("http://i.am/an/url")
    end

    it 'handles a missing signup page' do
      product = double('product')
      allow(product).to receive(:price_in_cents)
      allow(product).to receive(:product_family).and_return(double('pf', id: 1))
      allow(product).to receive(:handle).and_return("plan_name")
      allow(product).to receive(:public_signup_pages).and_return([])
      expect(Chargify::Product).to receive(:all).and_return([product])
      Member.initialize_chargify_links!
      expect(Member::CHARGIFY_PRODUCT_LINKS["plan_name"]).to be_nil
    end

    it 'stores the price of the product' do
      product = double('product')
      page = double('page')
      allow(product).to receive(:price_in_cents).and_return(80000)
      allow(product).to receive(:product_family).and_return(double('pf', id: 1))
      allow(product).to receive(:handle).and_return("plan_name")
      allow(product).to receive(:public_signup_pages).and_return([])
      expect(Chargify::Product).to receive(:all).and_return([product])
      Member.initialize_chargify_links!
      expect(Member::CHARGIFY_PRODUCT_PRICES["plan_name"]).to eq(800)
    end

    it 'stores coupon discounts' do
      full = double('coupon',
        archived_at: nil,
        percentage: 100,
        code: "FULL")
      half = double('coupon',
        archived_at: nil,
        percentage: 50,
        code: "HALF")
      amount = double('coupon',
        archived_at: nil,
        percentage: nil,
        code: "AMOUNT")
      product1 = double('product', product_family: double(:id => 1), handle: 'a', public_signup_pages: [], price_in_cents: 1)
      product2 = double('product', product_family: double(:id => 2), handle: 'b', public_signup_pages: [], price_in_cents: 1)
      allow(Chargify::Product).to receive(:all).and_return([product1, product2])
      expect(Chargify::Coupon).to receive(:all).with(params: {product_family_id: 1}).and_return([full, amount])
      expect(Chargify::Coupon).to receive(:all).with(params: {product_family_id: 2}).and_return([half])
      Member.initialize_chargify_links!
      expect(Member::CHARGIFY_COUPON_DISCOUNTS).to eq({
        "FULL" => :free,
        "HALF" => :discount,
        "AMOUNT" => :discount
      })
    end

    it 'ignores archived coupons' do
      present = double('coupon',
        archived_at: nil,
        percentage: 100,
        code: "PRESENT")
      archived = double('coupon',
        archived_at: 3.days.ago,
        percentage: nil,
        code: "ARCHIVED")
      product = double('product', product_family: double(:id => 1), handle: 'a', public_signup_pages: [], price_in_cents: 1)
      allow(Chargify::Product).to receive(:all).and_return([product])
      expect(Chargify::Coupon).to receive(:all).with(params: {product_family_id: 1}).and_return([present, archived])
      Member.initialize_chargify_links!
      expect(Member::CHARGIFY_COUPON_DISCOUNTS).to eq({
        "PRESENT" => :free
      })
    end
  end

  describe 'price helpers for plan' do
    before do
      Member.register_chargify_product_link('individual-supporter', 'https://chargify.com/individiual')
      Member.register_chargify_product_price('individual-supporter', 9000)
      Member.register_chargify_product_link('supporter_annual', 'https://chargify.com/non-profit')
      Member.register_chargify_product_price('supporter_annual', 72000)
      Member.register_chargify_product_link('supporter_monthly', 'https://chargify.com/monthly-non-profit')
      Member.register_chargify_product_price('supporter_monthly', 6000)
    end

    it 'returns the price of the plan without vat' do
      m = Member.new(product_name: 'supporter')
      expect(m.get_plan_price).to eq("£720.00")
    end

    it 'returns the price with +VAT if in UK' do
      m = Member.new(product_name: 'supporter', address_country: 'GB')
      expect(m.get_plan_price).to eq("£720.00 + VAT")
    end

    it 'returns the price inclusive of vat for individuals' do
      m = Member.new(product_name: 'individual', address_country: 'GB')
      expect(m.get_plan_price).to eq("£108.00 including £18.00 VAT")
    end

    it 'returns a 12th of the yearly price for monthly price' do
      m = Member.new(product_name: 'supporter')
      expect(m.get_monthly_plan_price).to eq("£60.00")
    end

    it 'returns a 12th of the yearly price for monthly price +VAT if in UK' do
      m = Member.new(product_name: 'supporter', address_country: 'GB')
      expect(m.get_monthly_plan_price).to eq("£60.00 + VAT")
    end

  end

  describe 'chargify redirect link' do
    before do
      Member.register_chargify_product_link('individual-supporter', 'https://chargify.com/individual')
    end

    let(:member) do
      Member.create!(
        product_name: "individual",
        contact_name: "Test Person",
        email: 'test@example.com',
        street_address: "1 Street Over",
        address_locality: "Townplace",
        address_region: "London",
        address_country: "GB",
        postal_code: "EC1 1TT",
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: "1"
      )
    end

    let(:url) { URI.parse(member.chargify_product_link) }

    let(:params) do
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'links to the individiual product page' do
      expect(url.host).to eq("chargify.com")
      expect(url.path).to eq("/individual")
    end

    it 'includes membership number as customer reference' do
      expect(params).to include("reference" => member.membership_number)
    end

    it 'includes email' do
      expect(params).to include("email" => "test@example.com")
    end

    it 'includes street address as billing_address' do
      expect(params).to include("billing_address" => "1 Street Over")
    end

    it 'includes address locality as billing_address_2' do
      expect(params).to include("billing_address_2" => "Townplace")
    end

    it 'includes address region as billing_city' do
      expect(params).to include("billing_city" => "London")
    end

    it 'includes address country as billing_country' do
      expect(params).to include("billing_country" => "GB")
    end

    it 'includes postal code as billing_zip' do
      expect(params).to include("billing_zip" => "EC1 1TT")
    end

    it 'includes London as the billing_state as a hack to get tax to update in chargify' do
      expect(params).to include("billing_state" => "London")
    end

    it 'guesses and includes the first name' do
      expect(params).to include("first_name" => "Test")
    end

    it 'guesses and includes the last name' do
      expect(params).to include("last_name" => "Person")
    end
  end

  describe 'chargify redirect link for a organisation' do
    before do
      Member.register_chargify_product_link('corporate-supporter_annual', 'https://chargify.com/corporate')
      Member.register_chargify_product_link('supporter_annual', 'https://chargify.com/non-profit')
    end

    let(:member) do
      Member.create!(
        product_name: "supporter",
        contact_name: "Test Person",
        email: 'test@example.com',
        organization_name: "Test Org",
        organization_size: "251-1000",
        organization_type: "commercial",
        organization_sector: "Energy",
        street_address: "1 Street Over",
        address_locality: "Townplace",
        address_region: "London",
        address_country: "GB",
        postal_code: "EC1 1TT",
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: "1"
      )
    end

    let(:url) { URI.parse(member.chargify_product_link) }

    let(:params) do
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'links to the corporate product page' do
      expect(url.host).to eq("chargify.com")
      expect(url.path).to eq("/corporate")
    end

    it 'includes organization_name' do
      expect(params).to include("organization" => "Test Org")
    end
  end

  describe 'chargify redirect link for a non-commercial organisation' do
    before do
      Member.register_chargify_product_link('supporter_annual', 'https://chargify.com/non-profit')
      Member.register_chargify_product_link('corporate-supporter_annual', 'https://chargify.com/corporate')
    end

    let(:member) do
      Member.create!(
        product_name: "supporter",
        contact_name: "Test Person",
        email: 'test@example.com',
        organization_name: "Test Org",
        organization_size: "251-1000",
        organization_type: "non_commercial",
        organization_sector: "Energy",
        street_address: "1 Street Over",
        address_locality: "Townplace",
        address_region: "London",
        address_country: "GB",
        postal_code: "EC1 1TT",
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: "1"
      )
    end

    let(:url) { URI.parse(member.chargify_product_link) }

    let(:params) do
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'links to the non profit product page' do
      expect(url.host).to eq("chargify.com")
      expect(url.path).to eq("/non-profit")
    end
  end

  describe 'chargify redirect link for montly payment options' do
    before do
      Member.register_chargify_product_link('supporter_annual', 'https://chargify.com/non-profit')
      Member.register_chargify_product_link('supporter_monthly', 'https://chargify.com/monthly-non-profit')
      Member.register_chargify_product_link('corporate-supporter_annual', 'https://chargify.com/corporate')
    end

    let(:member) do
      Member.create!(
        product_name: "supporter",
        contact_name: "Test Person",
        email: 'test@example.com',
        organization_name: "Test Org",
        organization_size: "251-1000",
        organization_type: "non_commercial",
        organization_sector: "Energy",
        street_address: "1 Street Over",
        address_locality: "Townplace",
        address_region: "London",
        address_country: "GB",
        postal_code: "EC1 1TT",
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: "1"
      )
    end

    let(:url) { URI.parse(member.chargify_product_link) }

    let(:params) do
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'links to the non profit product page' do
      expect(member.payment_frequency).to eq("annual")
      expect(url.host).to eq("chargify.com")
      expect(url.path).to eq("/non-profit")
    end

    it 'links to the monthly non profit product page' do
      member.update_attribute(:payment_frequency, "monthly")
      expect(url.host).to eq("chargify.com")
      expect(url.path).to eq("/monthly-non-profit")
    end
  end

  describe 'chargify redirect link for member with a coupon code' do
    before do
      Member.register_chargify_product_link('supporter_annual', 'https://chargify.com/non-profit')
      Member.register_chargify_product_link('supporter_monthly', 'https://chargify.com/monthly-non-profit')
      Member.register_chargify_product_link('corporate-supporter_annual', 'https://chargify.com/corporate')
    end

    let(:member) do
      Member.create!(
        product_name: "supporter",
        contact_name: "Test Person",
        email: 'test@example.com',
        organization_name: "Test Org",
        organization_size: "251-1000",
        organization_type: "non_commercial",
        organization_sector: "Energy",
        street_address: "1 Street Over",
        address_locality: "Townplace",
        address_region: "London",
        address_country: "GB",
        postal_code: "EC1 1TT",
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: "1",
        coupon: "ODIALUMNI"
      )
    end

    let(:url) { URI.parse(member.chargify_product_link) }

    let(:params) do
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'appends a coupon code' do
      query = Rack::Utils.parse_query url.query
      expect(member.coupon).to eq("ODIALUMNI")
      expect(query["coupon_code"]).to eq("ODIALUMNI")
    end
  end

  describe 'summary' do
    it 'counts the total current members' do
      FactoryGirl.create_list(:current_member, 5)
      FactoryGirl.create_list(:member, 2, current: false)
      FactoryGirl.build(:member, product_name: nil).save(validate: false)

      expect(Member.summary[:total]).to eq 5
      expect(Member.summary[:all][:total]).to eq 7
    end

    it 'breaks down count of current members by product_name' do
      FactoryGirl.build(:member, product_name: nil).save(validate: false)
      FactoryGirl.create_list(:current_individual_member, 2)
      FactoryGirl.create_list(:individual_member, 1)
      breakdown = {supporter: 3, member: 2, partner: 1, sponsor: 4}
      breakdown.each do |product_name, count|
        FactoryGirl.build_list(:current_member, count, :product_name => product_name).map {|m| m.save(validate: false)}
        FactoryGirl.build_list(:member, 1, :product_name => product_name).map {|m| m.save(validate: false)}
      end

      expect(Member.summary[:breakdown]).to eq breakdown.merge(individual: 2).stringify_keys
      expect(Member.summary[:all][:breakdown]).to eq({individual: 3, supporter: 4, member: 3, partner: 2, sponsor: 5}.stringify_keys)
    end
  end

end
