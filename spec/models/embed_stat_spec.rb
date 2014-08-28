require 'spec_helper'

describe EmbedStat do

  it "returns an error if referrer is an invalid URL" do
    e = EmbedStat.create(referrer: "this is not a URL")

    e.valid?.should be_false
    e.errors.first.should == [:referrer, "is not a valid URL"]
  end

  it "generates a CSV of all embeds" do
    5.times.each do |n|
      member = FactoryGirl.create(:member, organization_name: "Member #{n}")
      2.times.each { |i| member.register_embed("http://example#{n}.com/#{i}") }
    end

    csv = CSV.parse(EmbedStat.csv)

    csv.count.should == 11

    csv.first.should == ["Member Name", "Referring URL", "First Detected"]

    csv[1][0].should == "Member 0"
    csv[1][1].should == "http://example0.com/0"
    Date.parse(csv[1][2]).should == Date.today

    csv.last[0].should == "Member 4"
    csv.last[1].should == "http://example4.com/1"
    Date.parse(csv.last[2]).should == Date.today
  end

end
