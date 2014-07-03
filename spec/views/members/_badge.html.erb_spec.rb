require 'spec_helper'

describe "members/_badge.html.erb" do

  before :all do
    @partner = FactoryGirl.create :member, :cached_active => true, :product_name => 'partner'
    @supporter = FactoryGirl.create :member, :cached_active => true, :product_name => 'supporter'
  end

  it "displays basic information on the badge" do
    assign(:member, @partner)

    render

    expect(rendered).to have_tag('a', with: { href: member_url(@partner) })
    expect(rendered).to have_tag('img', with: {
                                                src: "/assets/badge/partner/standard-badge.png",
                                                alt: "Open Data Institute Partner"
                                              })
  end

  it "shows a large badge if specified" do
    assign(:member, @partner)
    assign(:size, "large")

    render

    expect(rendered).to have_tag('img', with: { src: "/assets/badge/partner/large-badge.png" })
    expect(rendered).to have_tag('div', with: { class: "odi-member large"})
  end

  it "shows a mini badge if specified" do
    assign(:member, @partner)
    assign(:size, "mini")

    render

    expect(rendered).to have_tag('img', with: { src: "/assets/badge/partner/mini-badge.png" })
    expect(rendered).to have_tag('div', with: { class: "odi-member mini"})
  end

end
