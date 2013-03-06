require 'spec_helper'

describe ContactRequestsController do

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
