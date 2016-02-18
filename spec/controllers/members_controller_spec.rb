require 'spec_helper'

describe MembersController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:member]
  end

  describe "GET 'index'" do

    before :each do
      @member    = FactoryGirl.create :member, :cached_active => true, :product_name => 'supporter'
      @supporter = FactoryGirl.create :member, :cached_active => true, :product_name => 'supporter'
      @inactive  = FactoryGirl.create :member, :cached_active => false, :product_name => 'member'
    end

    it "shows only members with active flag set" do
      get 'index'
      expect(response).to be_success
      expect(assigns(:organizations)).to_not include(@inactive.organization)
    end

    it "shows all levels without filter" do
      get 'index'
      expect(response).to be_success
      expect(assigns(:organizations)).to include(@member.organization)
      expect(assigns(:organizations)).to include(@supporter.organization)
    end

    it "shows only requested levels" do
      get 'index', :level => 'supporter'
      expect(response).to be_success
      expect(assigns(:organizations)).to include(@member.organization)
    end
  end

  describe "GET 'show'" do

    it "returns http success if member is active" do
      member = FactoryGirl.create :current_member, :cached_active => true
      get 'show', :id => member.membership_number
      expect(response).to be_success
    end

    it "redirects to login if member is not active" do
      member = FactoryGirl.create :current_member, :cached_active => false
      get 'show', :id => member.membership_number
      expect(response).to be_redirect
    end

  end

  describe "GET 'badge'" do

    before :each do
      @member = FactoryGirl.create :current_active_member, :product_name => 'member'
    end

    it "allows specific sizes to be specified" do
      ['mini', 'small', 'medium', 'large'].each do |size|
        get 'badge', :id => @member.membership_number, :size => size
        expect(assigns(:size)).to be(size)
      end
    end

    it "doesn't allow bad sizes to be specified" do
      get 'badge', :id => @member.membership_number, :size => 'foobar'
      expect(assigns(:size)).to be(nil)
    end

    it "allows specific alignments to be specified" do
      ['left', 'right', 'top-left', 'top-right', 'bottom-left', 'bottom-right'].each do |align|
        get 'badge', :id => @member.membership_number, :align => align
        expect(assigns(:align)).to be(align)
      end
    end

    it "doesn't allow bad alignments to be specified" do
      get 'badge', :id => @member.membership_number, :align => 'foobar'
      expect(assigns(:align)).to be(nil)
    end

    it "allows specific colours to be specified" do
      ['black', 'blue', 'red', 'crimson', 'orange', 'green', 'pomegranate', 'grey'].each do |colour|
        get 'badge', :id => @member.membership_number, :colour => colour
        expect(assigns(:colour)).to be(colour)
      end
    end

    it "doesn't allow bad colours to be specified" do
      get 'badge', :id => @member.membership_number, :colours => 'puce'
      expect(assigns(:align)).to be(nil)
    end

    describe "embed stats"

      it "creates an embed stat when a badge is embeded" do
        allow(controller.request).to receive_messages(:referer => 'http://example.com')

        get 'badge', :id => @member.membership_number

        expect(EmbedStat.count).to eq(1)
        expect(EmbedStat.first.referrer).to eq('http://example.com')
      end

      it "doesn't create a stat when there is no referrer" do
        allow(controller.request).to receive_messages(:referer => nil)

        get 'badge', :id => @member.membership_number

        expect(EmbedStat.count).to eq(0)
      end

      it "doesn't create a stat when the referrer is local" do
        allow(controller.request).to receive_messages(:referer => 'http://test.host/example.html')

        get 'badge', :id => @member.membership_number

        expect(EmbedStat.count).to eq(0)
      end

  end

  describe "content locations" do
    let!(:member) { FactoryGirl.create :current_active_member }

    it "includes query parameters" do
      get 'index', :page => 3
      expect(response.headers['Content-Type']).to include('text/html')
      expect(response.headers['Content-Location']).to eq("http://test.host/members.html?page=3")
    end

    it "shows HTML extension" do
      get 'show', :id => member.membership_number
      expect(response.headers['Content-Type']).to include('text/html')
      expect(response.headers['Content-Location']).to eq("http://test.host/members/#{member.membership_number}.html")
    end

    it "includes JSON extension if requesting JSON via format in URI" do
      get 'show', :id => member.membership_number, :format => 'json'
      expect(response.headers['Content-Type']).to include('application/json')
      expect(response.headers['Content-Location']).to eq("http://test.host/members/#{member.membership_number}.json")
    end

    it "includes JSON extension if requesting JSON via content negotiation" do
      @request.accept = 'application/json'
      get 'show', :id => member.membership_number
      expect(response.headers['Content-Type']).to include('application/json')
      expect(response.headers['Content-Location']).to eq("/members/#{member.membership_number}.json")
    end

  end

  describe 'verifying chargify customers' do
    let(:event) do
      JSON.load(Rails.root + 'fixtures/chargify/signup_success.json')
    end

    let(:valid_data) { {chargify_subscription_id: 14, chargify_customer_id: 15, chargify_payment_id: 30} }

    subject(:member) { FactoryGirl.create :member }

    before do
      allow(controller).to receive(:verify_chargify_webhook)
      event['payload']['subscription']['customer']['reference'] = member.membership_number
    end

    it "responds with an ok" do
      post :chargify_verify, event
      expect(response).to be_success
    end

    it "checks the customers details and marks them as verified" do
      post :chargify_verify, event
      member.reload
      expect(member.chargify_subscription_id).to eq("14")
      expect(member.chargify_customer_id).to eq("15")
      expect(member.chargify_payment_id).to eq("30")
      expect(member).to be_chargify_data_verified
    end

    it 'responds with an ok to a test webhook' do
      post :chargify_verify, event: "test", id: rand(1000), payload: { chargify: "test" }
      expect(response).to be_success
    end

  end

  describe 'individual return from chargify' do
    let!(:member) { FactoryGirl.create(:individual_member) }

    let(:response) do
      sign_in(member)
      # chargify return parameters template
      # reference={customer_reference}&customer_id={customer_id}&subscription_id={subscription_id}&payment_id={signup_payment_id}
      get :chargify_return, reference: member.membership_number, customer_id: 1, subscription_id: 2, payment_id: 3
    end

    it 'redirects to thanks page' do
      expect(response).to be_redirect
      expect(response).to redirect_to(thanks_member_path(member))
    end

    {
      chargify_customer_id: 1,
      chargify_subscription_id: 2,
      chargify_payment_id: 3,
    }.each do |chargify_param, id|
      it "updates #{chargify_param} on member record" do
        response
        expect(member.reload.send(chargify_param)).to eq(id.to_s)
      end
    end
  end

  describe 'payment page' do

    let!(:member) do
      FactoryGirl.create(:individual_member)
    end

    it 'renders the payment page for a newly created user' do
      sign_in(member)
      response = get :payment, id: member.to_param
      expect(response).to be_success
      expect(response).to render_template("members/payment")
    end

    it 'redirects to member page if already paid' do
      sign_in(member)
      member.update_attribute(:current, true)
      response = get :payment, id: member.to_param
      expect(response).to be_redirect
      expect(response).to redirect_to(member_path(member))
    end

    it 'redirects to chargify link on post' do
      allow_any_instance_of(ChargifyProductLink).to receive(:url).and_return("http://chargify.com/buy/this")
      sign_in(member)
      response = post :payment, id: member.to_param
      expect(response).to be_redirect
      expect(response).to redirect_to("http://chargify.com/buy/this")
    end

    it 'updates payment frequency to monthly if provided' do
      allow_any_instance_of(ChargifyProductLink).to receive(:url).and_return("http://chargify.com/buy/this")
      sign_in(member)
      response = post :payment, id: member.to_param, payment_frequency: 'monthly'
      expect(response).to be_redirect
      expect(response).to redirect_to("http://chargify.com/buy/this")
      expect(member.reload.payment_frequency).to eq("monthly")
    end
  end
end
