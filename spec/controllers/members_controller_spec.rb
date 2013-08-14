require 'spec_helper'

describe MembersController do

  describe "GET 'index'" do

    before :all do
      @member    = FactoryGirl.create :member, :cached_active => true, :product_name => 'member'
      @supporter = FactoryGirl.create :member, :cached_active => true, :product_name => 'supporter'
      @inactive  = FactoryGirl.create :member, :cached_active => false, :product_name => 'member'
    end

    it "shows only members with active flag set" do
      get 'index'
      response.should be_success
      assigns(:organizations).should_not include(@inactive.organization)
    end

    it "shows all levels without filter" do
      get 'index'
      response.should be_success
      assigns(:organizations).should include(@member.organization)
      assigns(:organizations).should include(@supporter.organization)
    end

    it "shows only requested levels" do
      get 'index', :level => 'member'
      response.should be_success
      assigns(:organizations).should include(@member.organization)
      assigns(:organizations).should_not include(@supporter.organization)
    end

  end

  describe "GET 'show'" do

    it "returns http success if member is active" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'show', :id => member.membership_number
      response.should be_success
    end

    it "redirects to login if member is not active" do
      member = FactoryGirl.create :member, :cached_active => false
      get 'show', :id => member.membership_number
      response.should be_redirect
    end

  end

  describe "content locations" do

    it "includes query parameters" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'index', :page => 3
      response.headers['Content-Type'].should include('text/html')
      response.headers['Content-Location'].should == "http://test.host/members.html?page=3"
    end

    it "shows HTML extension" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'show', :id => member.membership_number
      response.headers['Content-Type'].should include('text/html')
      response.headers['Content-Location'].should == "http://test.host/members/#{member.membership_number}.html"
    end

    it "includes JSON extension if requesting JSON via format in URI" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'show', :id => member.membership_number, :format => 'json'
      response.headers['Content-Type'].should include('application/json')
      response.headers['Content-Location'].should == "http://test.host/members/#{member.membership_number}.json"
    end

    it "includes JSON extension if requesting JSON via content negotiation" do
      member = FactoryGirl.create :member, :cached_active => true
      @request.accept = 'application/json'
      get 'show', :id => member.membership_number
      response.headers['Content-Type'].should include('application/json')
      response.headers['Content-Location'].should == "/members/#{member.membership_number}.json"
    end

  end

end
