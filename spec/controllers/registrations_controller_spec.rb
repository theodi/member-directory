require 'spec_helper'

describe RegistrationsController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:member]
  end
  
  it 'should show form for supporter level signups' do
    get :new, :level => 'supporter'
    response.should be_success
  end
  
  it 'should show form for member level signups' do
    get :new, :level => 'member'
    response.should be_success
  end
  
  it 'should show form for partner level signups' do
    get :new, :level => 'partner'
    response.should be_success
  end
  
  it 'should show form for sponsor level signups' do
    get :new, :level => 'sponsor'
    response.should be_success
  end

  it 'should redirect back to join us page for any other level' do
    get :new, :level => 'spaceman'
    response.should be_redirect
    response.should redirect_to('http://www.theodi.org/join-us')
  end

  it 'should redirect back to join us page for no level' do
    get :new
    response.should be_redirect
    response.should redirect_to('http://www.theodi.org/join-us')
  end

end
