require 'spec_helper'

describe MembersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      @member = FactoryGirl.create :member
      get 'show', :id => @member.membership_number
      response.should be_success
    end
  end

end
