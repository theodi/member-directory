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
      get 'index', :level => 'member'
      expect(response).to be_success
      expect(assigns(:organizations)).to include(@member.organization)
      expect(assigns(:organizations)).to_not include(@supporter.organization)
    end

  end

  describe "GET 'show'" do

    it "returns http success if member is active" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'show', :id => member.membership_number
      expect(response).to be_success
    end

    it "redirects to login if member is not active" do
      member = FactoryGirl.create :member, :cached_active => false
      get 'show', :id => member.membership_number
      expect(response).to be_redirect
    end

  end

  describe "GET 'badge'" do

    before :all do
      @member = FactoryGirl.create :member, :cached_active => true, :product_name => 'member'
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

    it "includes query parameters" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'index', :page => 3
      expect(response.headers['Content-Type']).to include('text/html')
      expect(response.headers['Content-Location']).to eq("http://test.host/members.html?page=3")
    end

    it "shows HTML extension" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'show', :id => member.membership_number
      expect(response.headers['Content-Type']).to include('text/html')
      expect(response.headers['Content-Location']).to eq("http://test.host/members/#{member.membership_number}.html")
    end

    it "includes JSON extension if requesting JSON via format in URI" do
      member = FactoryGirl.create :member, :cached_active => true
      get 'show', :id => member.membership_number, :format => 'json'
      expect(response.headers['Content-Type']).to include('application/json')
      expect(response.headers['Content-Location']).to eq("http://test.host/members/#{member.membership_number}.json")
    end

    it "includes JSON extension if requesting JSON via content negotiation" do
      member = FactoryGirl.create :member, :cached_active => true
      @request.accept = 'application/json'
      get 'show', :id => member.membership_number
      expect(response.headers['Content-Type']).to include('application/json')
      expect(response.headers['Content-Location']).to eq("/members/#{member.membership_number}.json")
    end

  end

end
