require 'spec_helper'

describe Listing do

  context "validations" do
    before :each do
      @member = FactoryGirl.create :member
    end

    it "should strip prefix from twitter handles before saving" do
      org = FactoryGirl.create :listing, :twitter => "@test1", :member => @member
      expect(org.twitter).to eq("test1")
      org = FactoryGirl.create :listing, :twitter => "test2", :member => @member
      expect(org.twitter).to eq("test2")
    end

    it "cannot create listings with the same name" do
      name = Faker::Company.name
      FactoryGirl.create :listing, :name => name, :member => @member
      expect {
        FactoryGirl.create :listing, :name => name, :member => @member
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "can create two listings with no name" do
      expect {
        FactoryGirl.create :listing, :name => nil, :member => @member
        FactoryGirl.create :listing, :name => nil, :member => @member
      }.to change{Listing.count}.by(2)
    end
  end

  context "scopes" do

    def listing(options={})
      values = {
        organization_name: options[:name],
        product_name: options[:type]
      }.reject {|k, v| v.nil? }

      (FactoryGirl.create :member, values).listing
    end

    context "display order" do
      it "sorts alphabetically" do
        g = listing(:name => 'Grace')
        b = listing(:name => 'Betty')
        a = listing(:name => 'Ace')

        expect(Listing.display_order).to eq([a,b,g])
      end

      it "sorts by partner, sponsor, member, supporter" do
        supporter = listing(:type => 'supporter')
        sponsor = listing(:type => 'sponsor')
        member = listing()
        member.member.update_attribute(:product_name, 'member')
        partner = listing(:type => 'partner')
        expect(Listing.display_order).to eq([partner, sponsor, member, supporter])
      end

      it "sorts by founding partner first" do
        partner = listing(:name => 'a', :type => 'partner')
        founding_partner = listing(:name => 'z', :type => 'partner')
        founding_partner.member.update_attribute(:membership_number, Member.founding_partner_id)
        expect(founding_partner.member).to be_founding_partner
        expect(Listing.display_order).to eq([founding_partner, partner])
      end
    end

    context "filtering by alpha group" do
      it "returns listing in a group" do
        a1 = listing(:name => "Alice")
        a2 = listing(:name => "Agile")
        listing(:name => "Eve")

        expect(Listing.in_alpha_group("A")).to eq([a1, a2])
      end
    end
  end
end
