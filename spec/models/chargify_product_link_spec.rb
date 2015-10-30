# encoding: utf-8
require 'spec_helper'

describe ChargifyProductLink do

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

    let(:url) do
      url = ChargifyProductLink.for(member)
      URI.parse(url)
    end

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

    let(:url) do
      url = ChargifyProductLink.for(member)
      URI.parse(url)
    end

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

    let(:url) do
      url = ChargifyProductLink.for(member)
      URI.parse(url)
    end

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

    let(:url) do
      url = ChargifyProductLink.for(member)
      URI.parse(url)
    end

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

    let(:url) do
      url = ChargifyProductLink.for(member)
      URI.parse(url)
    end

    let(:params) do
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'appends a coupon code' do
      query = Rack::Utils.parse_query url.query
      expect(member.coupon).to eq("ODIALUMNI")
      expect(query["coupon_code"]).to eq("ODIALUMNI")
    end
  end
end

