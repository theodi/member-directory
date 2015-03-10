require 'spec_helper'

describe Organization do

  context "validations" do
    before :each do
      @member = FactoryGirl.create :member
    end

    it "should strip prefix from twitter handles before saving" do
      org = FactoryGirl.create :organization, :cached_twitter => "@test1", :member => @member
      expect(org.cached_twitter).to eq("test1")
      org = FactoryGirl.create :organization, :cached_twitter => "test2", :member => @member
      expect(org.cached_twitter).to eq("test2")
    end

    it "cannot create organizations with the same name" do
      name = Faker::Company.name
      FactoryGirl.create :organization, :name => name, :member => @member
      expect {
        FactoryGirl.create :organization, :name => name, :member => @member
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "can create two organizations with no name" do
      expect {
        FactoryGirl.create :organization, :name => nil, :member => @member
        FactoryGirl.create :organization, :name => nil, :member => @member
      }.to change{Organization.count}.by(2)
    end
  end

  context "scopes" do

    def organization(options={})
      values = {
        organization_name: options[:name],
        product_name: options[:type]
      }.reject {|k, v| v.nil? }

      (FactoryGirl.create :member, values).organization
    end

    context "display order" do
      it "sorts alphabetically" do
        g = organization(:name => 'Grace')
        b = organization(:name => 'Betty')
        a = organization(:name => 'Ace')

        expect(Organization.display_order).to eq([a,b,g])
      end

      it "sorts by partner, sponsor, member, supporter" do
        supporter = organization(:type => 'supporter')
        sponsor = organization(:type => 'sponsor')
        member = organization()
        member.member.update_attribute(:product_name, 'member')
        partner = organization(:type => 'partner')
        expect(Organization.display_order).to eq([partner, sponsor, member, supporter])
      end

      it "sorts by founding partner first" do
        partner = organization(:name => 'a', :type => 'partner')
        founding_partner = organization(:name => 'z', :type => 'partner')
        founding_partner.member.update_attribute(:membership_number, Member.founding_partner_id)
        expect(founding_partner.member).to be_founding_partner
        expect(Organization.display_order).to eq([founding_partner, partner])
      end
    end

    context "filtering by alpha group" do
      it "returns organizations in a group" do
        a1 = organization(:name => "Alice")
        a2 = organization(:name => "Agile")
        organization(:name => "Eve")

        expect(Organization.in_alpha_group("A")).to eq([a1, a2])
      end
    end
  end
end
