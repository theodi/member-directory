require 'spec_helper'

describe Member do

  before(:each) do
    @member = FactoryGirl.create(:member)
  end

  it "creates an embed stat" do
    @member.register_embed("http://www.example.com/page")

    stat = @member.embed_stats.first

    expect(stat.referrer).to eq("http://www.example.com/page")
    expect(stat.member).to eq(@member)
  end

  it "only creates one embed stat per referrer" do
    2.times do
      @member.register_embed("http://www.example.com/page")
    end

    expect(@member.embed_stats.count).to eq(1)
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
    end

    it 'assigns the api handle and first public signup page' do
      product = double('product')
      page = double('page')
      allow(page).to receive(:url).and_return("http://i.am/an/url")
      allow(product).to receive(:price_in_cents)
      allow(product).to receive(:handle).and_return("plan_name")
      allow(product).to receive(:public_signup_pages).and_return([page])
      expect(Chargify::Product).to receive(:all).and_return([product])
      Member.initialize_chargify_links!
      expect(Member::CHARGIFY_PRODUCT_LINKS["plan_name"]).to eq("http://i.am/an/url")
    end

    it 'handles a missing signup page' do
      product = double('product')
      allow(product).to receive(:price_in_cents)
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
      allow(product).to receive(:handle).and_return("plan_name")
      allow(product).to receive(:public_signup_pages).and_return([])
      expect(Chargify::Product).to receive(:all).and_return([product])
      Member.initialize_chargify_links!
      expect(Member::CHARGIFY_PRODUCT_PRICES["plan_name"]).to eq(800)
    end
  end

end
