require "rack"

require_relative "../../app/models/chargify_product_link"

describe ChargifyProductLink do

  subject { ChargifyProductLink.new(member) }

  let(:config_file) { "./config/chargify.yml" }

  let(:env) { "test" }

  let(:member) { double("Member") }

  before do
    subject.env = env
    subject.config_file = config_file
  end

  describe '#url' do

    let(:member) do
      double("Member",
        product_name: "individual",
        contact_name: "Test Person",
        email: 'test@example.com',
        street_address: "1 Street Over",
        address_locality: "Townplace",
        address_region: "London",
        address_country: "GB",
        postal_code: "EC1 1TT",
        membership_number: "ABC123",
        coupon: "ACOUPON",
        organization?: false
      )
    end

    before do
     ENV["CHARGIFY_PRODUCT_URL"] = "https://theodi.chargify.com/subscribe/%s/%s"
     ENV["CHARGIFY_PAGE_IDS"] = "individual_supporter,1234"

     allow(member).to receive(:individual?).and_return(true)
     allow(member).to receive(:plan).and_return("individual-supporter")
     allow(member).to receive(:subscription_amount).and_return(10)
     allow(member).to receive(:price_without_vat).and_return(8.33)
    end

    let(:url) do
      URI.parse(subject.url)
    end

    let(:params) do
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'includes member details in the querystring' do
      expect(params).to include("reference" => "ABC123")
      expect(params).to include("email" => "test@example.com")
      expect(params).to include("billing_address" => "1 Street Over")
      expect(params).to include("billing_address_2" => "Townplace")
      expect(params).to include("billing_city" => "London")
      expect(params).to include("billing_country" => "GB")
      expect(params).to include("billing_zip" => "EC1 1TT")
      expect(params).to include("billing_state" => "London")
      expect(params).to include("first_name" => "Test")
      expect(params).to include("last_name" => "Person")
      expect(params).to include("coupon_code" => "ACOUPON")
      expect(params["components"][0]).to include("component_id" => ENV['CHARGIFY_COMPONENT_ID'])
      expect(params["components"][0]).to include("allocated_quantity" => "8.33")
    end
  end

  describe "#public_signup_page_key" do
    let(:member) do
      double("Member",
        :individual?                   => false,
        :student?                      => false,
        :student_free?                 => false,
        :large_corporate_organization? => false,
        :supporter?                    => false,
        :payment_frequency             => nil,
        :no_payment?                   => false
      )
    end

    context "individual" do
      it "should return 'individual_pay_what_you_like'" do
        allow(member).to receive(:individual?).and_return(true)

        expect(subject.public_signup_page_key).to eq(:individual_pay_what_you_like)
      end
    end

    context "student" do
      it "should return 'individual_supporter_student'" do
        allow(member).to receive(:student?).and_return(true)

        expect(subject.public_signup_page_key).to eq(:individual_supporter_student)
      end
    end

    context "free student" do
      it "should return 'individual_supporter_student_free'" do
        allow(member).to receive(:student?).and_return(true)
        allow(member).to receive(:no_payment?).and_return(true)

        expect(subject.public_signup_page_key).to eq(:individual_supporter_student_free)
      end
    end

    context "large corporate organization" do
      it "should return 'corporate_supporter_annual'" do
        allow(member).to receive(:large_corporate_organization?).and_return(true)

        expect(subject.public_signup_page_key).to eq(:corporate_supporter_annual)
      end
    end

    context "supporter paying monthly" do
      it "should return 'supporter_monthly'" do
        allow(member).to receive(:supporter?).and_return(true)
        allow(member).to receive(:payment_frequency).and_return("monthly")

        expect(subject.public_signup_page_key).to eq(:supporter_monthly)
      end
    end

    context "supporter paying annually" do
      it "should return 'supporter_annual'" do
        allow(member).to receive(:supporter?).and_return(true)

        expect(subject.public_signup_page_key).to eq(:supporter_annual)
      end
    end

  end

  describe "#product_handle" do
    it "returns the product handle" do
      allow(member).to receive(:plan).and_return("plan")

      expect(subject.product_handle).to eq("plan")
    end
  end

  describe '#product_url' do
    it "returns the product url" do
      expect(subject.product_url).to eq("https://theodi-testing.chargify.com/subscribe/%s/%s")
    end
  end

  describe "#product_links" do
    it "should parse and return the links" do
      expect(subject.product_links).to include(
        :individual_supporter_student      => "123",
        :individual_supporter_student_free => "456",
        :supporter_monthly                 => "789",
        :individual_pay_what_you_like      => "111213",
        :supporter_annual                  => "345",
        :corporate_supporter_annual        => "678"
      )
    end
  end

  # TODO Should we test for this somewhere?
  #   it 'includes organization_name' do
  #     expect(params).to include("organization" => "Test Org")
  #   end
  # end

end
