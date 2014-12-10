require 'spec_helper'

describe RegistrationsController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:member]
  end
  
  it 'should show form for supporter level signups' do
    get :new, :level => 'supporter'
    expect(response).to be_success
  end
  
  it 'should no longer show form for member level signups' do
    get :new, :level => 'member'
    expect(response).to be_redirect
    expect(response).to redirect_to('http://www.theodi.org/join-us')
  end
  
  it 'should show form for partner level signups' do
    get :new, :level => 'partner'
    expect(response).to be_success
  end
  
  it 'should show form for sponsor level signups' do
    get :new, :level => 'sponsor'
    expect(response).to be_success
  end

  it 'should redirect back to join us page for any other level' do
    get :new, :level => 'spaceman'
    expect(response).to be_redirect
    expect(response).to redirect_to('http://www.theodi.org/join-us')
  end

  it 'should redirect back to join us page for no level' do
    get :new
    expect(response).to be_redirect
    expect(response).to redirect_to('http://www.theodi.org/join-us')
  end

end
