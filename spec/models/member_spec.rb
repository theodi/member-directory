require 'spec_helper'

describe Member do

  before(:each) do
    @member = FactoryGirl.create(:member)
  end

  it "creates an embed stat" do
    @member.register_embed("http://www.example.com/page")

    @member.embed_stats.count.should == 1
    @member.embed_stats.first.referrer.should == "http://www.example.com/page"
  end

  it "only creates one embed stat per referrer" do
    2.times do
      @member.register_embed("http://www.example.com/page")
    end

    @member.embed_stats.count.should == 1
  end

end
