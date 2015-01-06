require 'spec_helper'

describe Member do

  before(:each) do
    @member = FactoryGirl.create(:member)
  end

  it "creates an embed stat" do
    @member.register_embed("http://www.example.com/page")

    stat = @member.embed_stats.first

    expect(stat.referrer).to eq("http://www.example.com/page")
    expect(stat.member).to eq(@member)
  end

  it "only creates one embed stat per referrer" do
    2.times do
      @member.register_embed("http://www.example.com/page")
    end

    expect(@member.embed_stats.count).to eq(1)
  end

end
