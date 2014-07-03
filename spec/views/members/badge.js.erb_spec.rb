require 'spec_helper'

describe "members/badge.js.erb" do

  before :all do
    @member = FactoryGirl.create :member, :cached_active => true, :product_name => 'member'
  end

  it "displays basic information on the badge" do
    assign(:member, @member)

    render

    expect(rendered).to match /#{member_url(@member)}/
    expect(rendered).to match /standard-badge.png/
  end

  it "shows a large badge if specified" do
    assign(:member, @member)
    assign(:size, "large")

    render

    expect(rendered).to match /large-badge.png/
    expect(rendered).to match /odi-member large/
  end

  it "shows a mini badge if specified" do
    assign(:member, @member)
    assign(:size, "mini")

    render

    expect(rendered).to match /mini-badge.png/
    expect(rendered).to match /odi-member mini/
  end

end
