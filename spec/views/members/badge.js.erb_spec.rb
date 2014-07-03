require 'spec_helper'

describe "members/badge.js.erb" do

  before :all do
    @member = FactoryGirl.create :member, :cached_active => true, :product_name => 'member'
  end

  it "displays basic information on the badge" do
    assign(:member, @member)

    render

    expect(rendered).to match /#{member_url(@member)}/
    expect(rendered).to match /large-badge.png/
  end

end
