require 'spec_helper'

describe Listing do

  context "validations" do
    before :each do
      @member = FactoryGirl.create :member
    end

    it "should strip prefix from twitter handles before saving" do
      org = FactoryGirl.create :member_with_listing, :organization_twitter => "@test1"
      expect(org.organization_twitter).to eq("test1")
      org = FactoryGirl.create :member_with_listing, :organization_twitter => "test2"
      expect(org.organization_twitter).to eq("test2")
    end

    it "should add prefix to URL before saving" do
      org = FactoryGirl.create :member_with_listing, :organization_url => "https://google.com"
      expect(org.organization_url).to eq("https://google.com")
      org = FactoryGirl.create :member_with_listing, :organization_url => "http://google.com"
      expect(org.organization_url).to eq("http://google.com")
      org = FactoryGirl.create :member_with_listing, :organization_url => "google.com"
      expect(org.organization_url).to eq("http://google.com")
    end

    it "cannot create listings with the same name" do
      name = Faker::Company.name
      FactoryGirl.create :member_with_listing, :organization_name => name
      expect {
        FactoryGirl.create :member_with_listing, :organization_name => name
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  context "scopes" do

    context "display order" do
      
      it "sorts alphabetically" do
        g = FactoryGirl.create :member, :organization_name => 'Grace'
        b = FactoryGirl.create :member, :organization_name => 'Betty'
        a = FactoryGirl.create :member, :organization_name => 'Ace'

        expect(Member.display_order).to eq([a,b,g])
      end

      it "sorts by partner, sponsor, member, supporter" do
        supporter = FactoryGirl.create :member, :product_name => 'supporter'
        sponsor = FactoryGirl.create :member, :product_name => 'sponsor'
        member = FactoryGirl.create :member
        member.update_attribute(:product_name, 'member')
        partner = FactoryGirl.create :member, :product_name => 'partner'
        expect(Member.display_order).to eq([partner, sponsor, member, supporter])
      end

      it "sorts by founding partner first" do
        partner = FactoryGirl.create :member, :organization_name => 'a', :product_name => 'partner'
        founding_partner = FactoryGirl.create :member, :organization_name => 'z', :product_name => 'partner', :membership_number => Member.founding_partner_id
        expect(founding_partner).to be_founding_partner
        expect(Member.display_order).to eq([founding_partner, partner])
      end
    end

    context "filtering by alpha group" do
      it "returns listing in a group" do
        a1 = FactoryGirl.create :member, :organization_name => "Alice"
        a2 = FactoryGirl.create :member, :organization_name => "Agile"
        FactoryGirl.create :member, :organization_name => "Eve"

        expect(Member.in_alpha_group("A")).to eq([a1, a2])
      end
    end
  end
end
