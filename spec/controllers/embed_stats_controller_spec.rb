require 'spec_helper'

describe EmbedStatsController do

  it "lists all embed stats as a CSV" do
    member = FactoryGirl.create :member
    member.register_embed("http://example.com")

    get 'index'

    expect(response).to be_success
    expect(response.headers['Content-Type']).to eq('text/csv; header=present; charset=utf-8')

    csv = CSV.parse(response.body)

    expect(csv.count).to eq(2)
  end

end
