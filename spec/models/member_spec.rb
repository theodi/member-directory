# encoding: utf-8
require 'spec_helper'

describe Member do

  let(:member) do
    FactoryGirl.create(:member)
  end

  it "creates an embed stat" do
    member.register_embed("http://www.example.com/page")

    stat = member.embed_stats.first

    expect(stat.referrer).to eq("http://www.example.com/page")
    expect(stat.member).to eq(member)
  end

  it "only creates one embed stat per referrer" do
    2.times do
      member.register_embed("http://www.example.com/page")
    end

    expect(member.embed_stats.count).to eq(1)
  end

  context "creating a member" do
    %w[organization_name organization_size organization_type organization_sector].each do |name|
      it "requires an #{name}" do
        (member = Member.new).valid?
        expect(member.errors[name.to_sym]).to include("can't be blank")
      end
    end

    it "requires organization_size to be in options" do
      (member = Member.new).valid?
      expect(member.errors[:organization_size]).to include("is not included in the list")
      %w[<10 10-50 51-250 251-1000 >1000].each do |option|
        member.organization_size = option
        member.valid?
        expect(member.errors[:organization_size]).to_not include("is not included in the list")
      end
    end

    it "fails if organization name is already taken" do
      FactoryGirl.create(:member, :organization_name => "Acme")
      (member = Member.new(:organization_name => "Acme")).valid?
      expect(member.errors[:organization_name]).to include("has already been taken")
    end

    it 'strips spaces from organization name' do
      member = FactoryGirl.create(:member, :organization_name => '  Acme  ')
      expect(member.organization_name).to eq("Acme")
    end

  end

  describe "#plan" do

    context "member is a large corporate organization" do
      it "returns 'corporate-supporter_annual'" do
        member = Member.new
        member.organization_type = "commercial"
        member.organization_size = ">1000"

        expect(member.plan).to eq("corporate-supporter_annual")
      end
    end

    context "member is a supporter" do
      it "returns 'supporter_annual" do
        member = Member.new(product_name: "supporter")

        expect(member.plan).to eq("supporter_annual")
      end
    end
  end

  describe 'summary' do
    it 'counts the total current members' do
      FactoryGirl.create_list(:current_member, 5)
      FactoryGirl.create_list(:member, 2, current: false)
      FactoryGirl.build(:member, product_name: nil).save(validate: false)

      expect(Member.summary[:total]).to eq 5
      expect(Member.summary[:all][:total]).to eq 7
    end

    it 'breaks down count of current members by product_name' do
      FactoryGirl.build(:member, product_name: nil).save(validate: false)
      breakdown = {supporter: 3, member: 2, partner: 1, sponsor: 4}
      breakdown.each do |product_name, count|
        FactoryGirl.build_list(:current_member, count, :product_name => product_name).map {|m| m.save(validate: false)}
        FactoryGirl.build_list(:member, 1, :product_name => product_name).map {|m| m.save(validate: false)}
      end

      expect(Member.summary[:all][:breakdown]).to eq({supporter: 4, member: 3, partner: 2, sponsor: 5}.stringify_keys)
    end
  end

  describe "#current!" do
    before do
      allow(member).to receive(:organization?).and_return(false)
    end

    it "sets the current flag" do
      member.current!

      expect(member.current).to eq(true)
    end

    context "member is an organization" do

      before do
        allow(member).to receive(:organization?).and_return(true)
      end

      it "sets the members #active flag" do
        member.current!
        expect(member.active).to eq(true)
      end

    end
  end

  describe "#unsubscribe_from_newsletter!" do

    let(:member) do
      FactoryGirl.create(
        :member,
        :newsletter => true
      )
    end

    it "sets the member's newsletter flag to false" do
      member.unsubscribe_from_newsletter!

      expect(member.newsletter).to eq(false)
    end
  end

  describe "#contact_name" do
    let(:member) do
      Member.new
    end

    it "returns the name" do
      member.name = "Test Person"

      expect(member.contact_name).to eq("Test Person")
    end
  end

  describe "#first_name" do
    let(:member) do
      Member.new
    end

    it "returns the name" do
      member.name = "Test Person"

      expect(member.first_name).to eq("Test")
    end
  end
end
