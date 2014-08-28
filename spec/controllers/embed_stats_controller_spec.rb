require 'spec_helper'

describe EmbedStatsController do

  it "lists all embed stats as a CSV" do
    member = FactoryGirl.create :member
    member.register_embed("http://example.com")

    get 'index'

    response.should be_success
    response.headers['Content-Type'].should == 'text/csv; header=present; charset=utf-8'

    csv = CSV.parse(response.body)

    csv.count.should == 2
  end

end
