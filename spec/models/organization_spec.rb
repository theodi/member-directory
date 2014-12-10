require 'spec_helper'

describe Organization do
  
  before :all do
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
