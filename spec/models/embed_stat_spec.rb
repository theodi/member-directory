require 'spec_helper'

describe EmbedStat do

  it "returns an error if referrer is an invalid URL" do
    e = EmbedStat.create(referrer: "this is not a URL")

    e.valid?.should be_false
    e.errors.first.should == [:referrer, "is not a valid URL"]
  end

end
