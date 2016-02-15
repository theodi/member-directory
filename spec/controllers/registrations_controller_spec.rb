require 'spec_helper'

describe RegistrationsController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:member]
  end

  %w[supporter individual student].each do |level|
    it "does allow a level of #{level}" do
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

  describe 'credit card signup via chargify' do

    let!(:response) do
      post :create, :member => {
        product_name: 'individual',
        contact_name: 'Test Person',
        email: 'test@example.com',
        street_address: '1 Street Over',
        address_locality: 'Townplace',
        address_region: 'London',
        address_country: 'GB',
        postal_code: 'EC1 1TT',
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: '1',
        subscription_amount: 6
      }
    end

    let!(:member) { Member.last }

    it 'redirects to payment page' do
      expect(response).to be_redirect
      expect(response.location).to eq(payment_member_url(member))
    end
  end

  describe 'member origin tracking' do
    let(:member) { Member.last }

    it 'defaults member origin to odihq' do
      post :create, :member => {
        product_name: 'individual',
        contact_name: 'Test Person',
        email: 'test@example.com',
        street_address: '1 Street Over',
        address_locality: 'Townplace',
        address_region: 'London',
        address_country: 'GB',
        postal_code: 'EC1 1TT',
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: '1',
        subscription_amount: 6
      }
      expect(member.origin).to eq('odihq')
    end

    it 'tracks origin field on member' do
      post :create, :member => {
        product_name: 'individual',
        contact_name: 'Test Person',
        email: 'test@example.com',
        street_address: '1 Street Over',
        address_locality: 'Townplace',
        address_region: 'London',
        address_country: 'GB',
        postal_code: 'EC1 1TT',
        password: 'testtest',
        password_confirmation: 'testtest',
        agreed_to_terms: '1',
        origin: 'odi-leeds',
        subscription_amount: 6
      }
      expect(member.origin).to eq('odi-leeds')
    end
  end
end
