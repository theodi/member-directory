require 'spec_helper'

describe MembersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do

    it "returns http success if member is active" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'show', :id => member.membership_number
      response.should be_success
    end

    it "returns 404 if member is not active" do
      member = FactoryGirl.create :member, :cached_active => false
      expect {
        get 'show', :id => member.membership_number
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

end
