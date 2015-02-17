require 'spec_helper'

describe "members/_badge.html.erb" do

  before :each do
    @partner = FactoryGirl.create :member, :cached_active => true, :product_name => 'partner'
    @supporter = FactoryGirl.create :member, :cached_active => true, :product_name => 'supporter'
  end

  it "displays basic information on the badge" do
    assign(:member, @partner)

    render

    expect(rendered).to have_tag('a', with: { href: member_url(@partner) })
    expect(rendered).to have_tag('div', with: { class: 'odi-partner' })
    expect(rendered).to have_tag('li') do
      with_text /Open Data Institute Partner/
    end
  end

  it "shows a large badge if specified" do
    assign(:member, @partner)
    assign(:size, "large")

    render

    expect(rendered).to have_tag('div', with: { class: "odi-partner large"})
  end

  it "shows a mini badge if specified" do
    assign(:member, @partner)
    assign(:size, "mini")

    render

    expect(rendered).to have_tag('div', with: { class: "odi-partner mini"})
  end

  it "displays supporter information on the badge" do
    assign(:member, @supporter)

    render

    expect(rendered).to have_tag('a', with: { href: member_url(@supporter) })
    expect(rendered).to have_tag('div', with: { class: 'odi-supporter' })
    expect(rendered).to have_tag('li') do
      with_text /Open Data Institute Supporter/
    end
  end

  it "allows alignment to be specified" do
    assign(:member, @supporter)
    assign(:align, "left")

    render

    expect(rendered).to have_tag('div', with: { class: "left" })
  end

end
