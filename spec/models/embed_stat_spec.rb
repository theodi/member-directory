require 'spec_helper'

describe EmbedStat do

  it "returns an error if referrer is an invalid URL" do
    e = EmbedStat.create(referrer: "this is not a URL")

    expect(e).to_not be_valid
    expect(e.errors.first).to eq([:referrer, "is not a valid URL"])
  end

  it "generates a CSV of all embeds" do
    5.times.each do |n|
      member = FactoryGirl.create(:member, organization_name: "Member #{n}")
      2.times.each { |i| member.register_embed("http://example#{n}.com/#{i}") }
    end

    validator = Csvlint::Validator.new(StringIO.new(EmbedStat.csv))
    expect(validator).to be_valid

    csv = CSV.parse(EmbedStat.csv)

    expect(csv.count).to eq(11)

    expect(csv.first).to eq(["Member Name", "Referring URL", "First Detected"])

    expect(csv[1][0]).to eq("Member 0")
    expect(csv[1][1]).to eq("http://example0.com/0")
    expect(Date.parse(csv[1][2])).to eq(Date.today)

    expect(csv.last[0]).to eq("Member 4")
    expect(csv.last[1]).to eq("http://example4.com/1")
    expect(Date.parse(csv.last[2])).to eq(Date.today)
  end

end
