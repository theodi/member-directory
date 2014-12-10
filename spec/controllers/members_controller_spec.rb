require 'spec_helper'

describe MembersController do

  describe "GET 'index'" do

    before :each do
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

  describe "GET 'badge'" do

    before :each do
      @member = FactoryGirl.create :member, :cached_active => true, :product_name => 'member'
    end

    it "allows specific sizes to be specified" do
      ['mini', 'small', 'medium', 'large'].each do |size|
        get 'badge', :id => @member.membership_number, :size => size
        assigns(:size).should be(size)
      end
    end

    it "doesn't allow bad sizes to be specified" do
      get 'badge', :id => @member.membership_number, :size => 'foobar'
      assigns(:size).should be(nil)
    end

    it "allows specific alignments to be specified" do
      ['left', 'right', 'top-left', 'top-right', 'bottom-left', 'bottom-right'].each do |align|
        get 'badge', :id => @member.membership_number, :align => align
        assigns(:align).should be(align)
      end
    end

    it "doesn't allow bad alignments to be specified" do
      get 'badge', :id => @member.membership_number, :align => 'foobar'
      assigns(:align).should be(nil)
    end

    it "allows specific colours to be specified" do
      ['black', 'blue', 'red', 'crimson', 'orange', 'green', 'pomegranate', 'grey'].each do |colour|
        get 'badge', :id => @member.membership_number, :colour => colour
        assigns(:colour).should be(colour)
      end
    end

    it "doesn't allow bad colours to be specified" do
      get 'badge', :id => @member.membership_number, :colours => 'puce'
      assigns(:align).should be(nil)
    end

    describe "embed stats"

      it "creates an embed stat when a badge is embeded" do
        controller.request.stub referer: 'http://example.com'

        get 'badge', :id => @member.membership_number

        EmbedStat.count.should == 1
        EmbedStat.first.referrer.should == 'http://example.com'
      end

      it "doesn't create a stat when there is no referrer" do
        controller.request.stub referer: nil

        get 'badge', :id => @member.membership_number

        EmbedStat.count.should == 0
      end

      it "doesn't create a stat when the referrer is local" do
        controller.request.should_receive(:referer).and_return('http://test.host/example.html')

        get 'badge', :id => @member.membership_number

        EmbedStat.count.should == 0
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
