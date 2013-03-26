require 'spec_helper'

describe Organization do
  
  it "should strip prefix from twitter handles before saving" do
    org = FactoryGirl.create :organization, :cached_twitter => "@test1"
    org.cached_twitter.should == "test1"
    org = FactoryGirl.create :organization, :cached_twitter => "test2"
    org.cached_twitter.should == "test2"
  end
  
end