require 'spec_helper'

describe RegistrationsController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:member]
  end
  
  %w[supporter individual].each do |level|
    it "does not allow a level of #{level}" do
      get :new, :level => level
      expect(response).to be_success
    end
  end
  
  %w[member partner sponsor spaceman].each do |level|
    it "does not allow a level of #{level}" do
      get :new, :level => level
      expect(response).to be_redirect
      expect(response).to redirect_to('http://www.theodi.org/join-us')
    end
  end
  
  it 'should redirect back to join us page for no level' do
    get :new
    expect(response).to be_redirect
    expect(response).to redirect_to('http://www.theodi.org/join-us')
  end

  describe 'individual credit card signup via chargify' do
    let!(:response) do
      post :create, :member => {
        product_name: "individual",
        contact_name: "Test Person",
        email: 'test@example.com',
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: "1"
      }
    end

    let!(:member) { Member.last }

    let!(:params) do
      url = URI.parse(response.location)
      Rack::Utils.parse_nested_query(url.query)
    end

    it 'redirects to chargify' do
      expect(response).to be_redirect
      expect(response.location).to match('chargify.com')
    end
    
    it 'includes membership number as customer reference' do
      expect(params).to include("reference" => member.membership_number)
    end
    
    it 'includes email' do
      expect(params).to include("email" => "test@example.com")
    end
  end

  describe 'individual return from chargify' do
    before do
      post :create, :member => {
        product_name: "individual",
        contact_name: "Test Person",
        email: 'test@example.com',
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: "1"
      }
    end

    let!(:member) { Member.last }

    let!(:response) do
      # chargify return parameters template
      # reference={customer_reference}&customer_id={customer_id}&subscription_id={subscription_id}&payment_id={signup_payment_id}&product_id={product_id}
      get :chargify_return, reference: member.membership_number, customer_id: 1, subscription_id: 2, payment_id: 3, product_id: 4
    end

    it 'redirects to member/edit page' do
      expect(response).to be_redirect
      expect(response).to redirect_to(member_path(member))
    end

    {
      chargify_customer_id: 1,
      chargify_subscription_id: 2,
      chargify_payment_id: 3,
      chargify_product_id: 4
    }.each do |chargify_param, id|
      it "updates #{chargify_param} on member record" do
        expect(member.reload.send(chargify_param)).to eq(id.to_s)
      end
    end
  end

  describe 'invoice signup' do
  end

end
