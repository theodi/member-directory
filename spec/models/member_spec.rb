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
      it "requires an #{name}" do
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
      member.save

      organization_errors = member.errors.select {|k,_| k.to_s.starts_with?('organization_') }
      expect(organization_errors).to be_empty
    end

    it "does not need organization details for an student" do
      member = Member.new(product_name: 'student')
      member.save

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

  context "deleting a member" do
    it "deletes the associated the organization when the member is destroyed" do
      member = FactoryGirl.create(:member)

      expect { member.destroy }.to change { Organization.count }.by(-1)
    end
  end

  context 'setting up chargify links' do
    before do
      Member::CHARGIFY_PRODUCT_PRICES.clear
      Member::CHARGIFY_COUPON_DISCOUNTS.clear
      allow(Chargify::Coupon).to receive(:all).and_return([])
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
        "FULL" => { :type => :free,     :percentage => 100 },
        "HALF" => { :type => :discount, :percentage => 50 }
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
        "PRESENT" => { :type => :free, :percentage => 100 }
      })
    end
  end

  describe 'price helpers for plan' do
    before do
      Member.register_chargify_product_price('individual-supporter', 9000)
      Member.register_chargify_product_price('individual-supporter-student', 9000)
      Member.register_chargify_product_price('supporter_annual', 72000)
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
      m = Member.new(product_name: 'individual', address_country: 'GB', subscription_amount: 6)
      expect(m.get_plan_price).to eq("£7.20 including £1.20 VAT")
    end

    it 'returns the price inclusive of vat for students' do
      m = Member.new(product_name: 'student', address_country: 'GB')
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

    it 'raises an error if a plan price cannot be found' do
      m = Member.new
      # Not ideal, but a necessity at the moment
      allow(m).to receive(:plan).and_return('plan-that-is-not-in-chargify')

      expect { m.get_plan_price }.to raise_error(RuntimeError, /Can't get product price for plan 'plan-that-is-not-in-chargify'\. Does it exist in Chargify\?/)
    end
  end

  describe "#plan" do
    context "member is individual" do
      it "returns 'individual-supporter-new'" do
        member = Member.new(product_name: "individual")

        expect(member.plan).to eq("individual-supporter-new")
      end
    end

    context "member is student" do
      it "returns 'individual-supporter-student'" do
        member = Member.new(product_name: "student")

        expect(member.plan).to eq("individual-supporter-student")
      end
    end

    context "member is a large corporate organization" do
      it "returns 'corporate-supporter_annual'" do
        member = Member.new
        member.organization_type = "commercial"
        member.organization_size = ">1000"

        expect(member.plan).to eq("corporate-supporter_annual")
      end
    end

    context "member is a supporter who pays monthly" do
      it "returns 'supporter_monthly'" do
        member = Member.new(product_name: "supporter")
        member.payment_frequency = "monthly"

        expect(member.plan).to eq("supporter_monthly")
      end
    end

    context "member is a supporter who pays annually" do
      it "returns 'supporter_annual" do
        member = Member.new(product_name: "supporter")
        member.payment_frequency = nil

        expect(member.plan).to eq("supporter_annual")
      end
    end
  end

  describe 'coupon_discount' do
    context 'member has a coupon' do
      it 'returns the coupon discount percentage amount' do
        stub_const("Member::CHARGIFY_COUPON_DISCOUNTS", {
          "TOTES_FREE" => {
            :type => :discount,
            :percentage => 50
          }
        })

        member.coupon = "TOTES_FREE"

        expect(member.coupon_discount).to eq 50
      end
    end

    context 'member does NOT have a coupon' do
      it 'returns nil' do
        expect(member.coupon_discount).to eq nil
      end
    end
  end

  describe 'invoiced?' do
    context 'member has invoice flag set to true' do
      it 'returns true' do
        member.invoice = true

        expect(member.invoiced?).to be true
      end
    end

    context 'member does NOT have invoice flag set' do
      it 'returns false' do
        member.invoice = nil

        expect(member.coupon_discount).to be_falsey
      end
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

  describe "#current!" do
    before do
      allow(member).to receive(:organization?).and_return(false)
    end

    it "sets the current flag" do
      member.current!

      expect(member.current).to eq(true)
    end

    context "member is an organization" do
      let(:organization) { double("Organization") }

      before do
        allow(member).to receive(:organization?).and_return(true)
        allow(member).to receive(:organization).and_return(organization)
      end

      it "sets the members #cached_active flag" do
        allow(UpdateDirectoryEntry).to receive(:update!).with(organization)

        member.current!

        expect(member.cached_active).to eq(true)
      end

      it "queues the directory entry if an organization" do
        expect(UpdateDirectoryEntry).to receive(:update!).with(organization)

        member.current!
      end
    end
  end

  describe "#unsubscribe_from_newsletter!" do

    let(:member) do
      FactoryGirl.create(
        :member,
        :cached_newsletter => true
      )
    end

    it "sets the member's newsletter flag to false" do
      member.unsubscribe_from_newsletter!

      expect(member.cached_newsletter).to eq(false)
    end
  end

  describe "#contact_name" do
    let(:member) do
      Member.new
    end

    it "returns the name" do
      member.name = "Test Person"

      expect(member.contact_name).to eq("Test Person")
    end
  end

  describe "#first_name" do
    let(:member) do
      Member.new
    end

    it "returns the name" do
      member.name = "Test Person"

      expect(member.first_name).to eq("Test")
    end
  end
end
