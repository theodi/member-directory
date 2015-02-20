Given /^that I want to sign up as a (\w*)$/ do |product_name|
  @product_name = product_name # Required
end

Given(/^chargify has a registered product for the "(.*?)" plan$/) do |plan|
  @chargify_product_url = "http://test.host/product/#{plan}"
  Member.register_chargify_product_link(plan, @chargify_product_url)
end

Given /^that I want to sign up$/ do
  @product_name = 'supporter'
end

Given /^there is already an organization with the name I want to use$/ do
  FactoryGirl.create :member, :organization_name => 'FooBar Inc'
end

Given /^there is already an organization with the name '(.*?)'$/ do |org_name|
  FactoryGirl.create :member, :organization_name => org_name
end

Given(/^I have a (sponsor|partner) account$/) do |level|
  pending

  @password = 'password'
  @email = Faker::Internet.email
  @member = FactoryGirl.create :member, :product_name => level, :organization_name => Faker::Company.name,
                         :password => @password, :password_confirmation => @password, :email => @email
  @member.confirm!
  @membership_number = @member.membership_number
  steps %{
    When I visit the sign in page
    And I enter my membership number and password
    And the password is correct
    And I click sign in
  }
end

Given(/^I visit my account page$/) do
  visit member_path(@member)
end

When /^I visit the signup page$/ do
  visit("/members/new?level=#{@product_name}")
  expect(page).to have_content 'Become an ODI member'
  @field_prefix = 'member'
end

When /^I enter my name and contact details$/ do
  @contact_name = 'Ian McIain'
  @email = 'iain@foobar.com'
  @telephone = '0121 123 446'

  fill_in('member_contact_name', :with => @contact_name)
  fill_in('member_email', :with => @email)
  fill_in('member_telephone', :with => @telephone)

  fill_in('member_password', :with => 'p4ssw0rd')
  fill_in('member_password_confirmation', :with => 'p4ssw0rd')
end

When /^I enter my address details$/ do
  @street_address = '123 Fake Street'
  @address_locality = 'Faketown'
  @address_region = 'Fakeshire'
  @address_country = 'United Kingdom'
  @postal_code = 'FAKE 123'

  fill_in('member_street_address', :with => @street_address)
  fill_in('member_address_locality', :with => @address_locality)
  fill_in('member_address_region', :with => @address_region)
  select(@address_country, from: :member_address_country, match: :first)
  fill_in('member_postal_code', :with => @postal_code)
end

When /^I enter my company details$/ do
  @organization_name = 'FooBar Inc'
  @organization_size = '251-1000'
  @organization_type = 'commercial'
  @organization_sector = 'Energy'
  @organization_vat_id = '213244343'
  @organization_company_number = '012345678'
  @purchase_order_number = 'PO-43243242342'

  fill_in('member_organization_name', :with => @organization_name)
  select(find_by_id('member_organization_size').
          find("option[value='#{@organization_size}']").text,
          from: 'member_organization_size')
  select(find_by_id('member_organization_type').
          find("option[value='#{@organization_type}']").text,
          from: 'member_organization_type')
  fill_in('member_organization_company_number',
          with: @organization_company_number)
  select(@organization_sector, from: 'member_organization_sector')
  fill_in('member_organization_vat_id', :with => @organization_vat_id)
  fill_in('member_purchase_order_number', :with => @purchase_order_number)
end

When /^I enter my details$/ do
  # Store for later
  @contact_name                = 'Ian McIain'
  @email                       = 'iain@foobar.com'
  @organization_sector         = 'Energy'
  @telephone                   = '0121 123 446'
  #@street_address              = '123 Fake Street'
  #@address_locality            = 'Faketown'
  #@address_region              = 'Fakeshire'
  #@address_country             = 'United Kingdom'
  #@postal_code                 = 'FAKE 123'

  # Fill in form
  fill_in('member_contact_name', :with => @contact_name)
  fill_in('member_email', :with => @email)
  fill_in('member_telephone', :with => @telephone)
  #fill_in('member_street_address', :with => @street_address)
  #fill_in('member_address_locality', :with => @address_locality)
  #fill_in('member_address_region', :with => @address_region)
  #select(@address_country, from: :member_address_country, match: :first)
  #fill_in('member_postal_code', :with => @postal_code)
  fill_in('member_password', :with => 'p4ssw0rd')
  fill_in('member_password_confirmation', :with => 'p4ssw0rd')

  unless @product_name == 'individual'
    @organization_name = 'FooBar Inc'
    @organization_size = '251-1000'
    @organization_type = 'commercial'
    @organization_vat_id = '213244343'
    @organization_company_number = '012345678'
    @purchase_order_number = 'PO-43243242342'

    fill_in('member_organization_name', :with => @organization_name)
    select(find_by_id('member_organization_size').
           find("option[value='#{@organization_size}']").text,
           from: 'member_organization_size')
    select(find_by_id('member_organization_type').
           find("option[value='#{@organization_type}']").text,
           from: 'member_organization_type')
    fill_in('member_organization_company_number',
            with: @organization_company_number)
    select(@organization_sector, from: 'member_organization_sector')
    fill_in('member_organization_vat_id', :with => @organization_vat_id)
    fill_in('member_purchase_order_number', :with => @purchase_order_number)
  end

  check('member_agreed_to_terms')
end

When /^I agree to the terms$/ do
  check('member_agreed_to_terms')
end

When /^I don't agree to the terms$/ do
  uncheck('member_agreed_to_terms')
end

When /^my passwords don't match$/ do
  fill_in('member_password_confirmation', :with => 'password')
end

When /^I click sign up$/ do
  click_button('submit')
end

When /^I pay via chargify and return to the member page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^my details should be queued for further processing$/ do

  organization   = {
    'name'           => @organization_name,
    'vat_id'         => @organization_vat_id,
    'company_number' => @organization_company_number,
    'size'           => @organization_size,
    'type'           => @organization_type,
    'sector'         => @organization_sector
  }
  contact_person = {
    'name'      => @contact_name,
    'email'     => @email,
    'telephone' => @telephone
  }
  billing        = {
    'name'           => @contact_name,
    'email'          => @email,
    'telephone'      => @telephone,
    'address'        => {
      'street_address'   => @street_address,
      'address_locality' => @address_locality,
      'address_region'   => @address_region,
      'address_country'  => @address_country,
      'postal_code'      => @postal_code
    }
  }

  expect(Resque).to receive(:enqueue) do |*args|
    expect(args[0]).to eql SignupProcessor
    expect(args[1]).to eql organization
    expect(args[2]).to eql contact_person
    expect(args[3]).to eql billing
    expect(args[4]['payment_method']).to eql @payment_method
    expect(args[4]['payment_ref']).to match @payment_ref if @payment_ref
    expect(args[4]['offer_category']).to eql @product_name
    expect(args[4]['membership_id']).not_to eql nil
    expect(args[4]['purchase_order_reference']).to eql @purchase_order_number
  end
end

And /^I should have a membership number generated$/ do
  @member         = Member.find_by_email(@email)
  @membership_number = @member.membership_number
  @membership_number.should_not be_nil
  @membership_number.should match(/[A-Z]{2}[0-9]{4}[A-Z]{2}/)
end

Then /^I should see an error relating to (.*)$/ do |text|
  expect(page.find(:css, "div.alert-error")).to have_content(text)
end

Then /^I should not see an error$/ do
  expect(page).to_not have_css("div.alert-error")
end

Then /^I should see that the membership level is invalid$/ do
  expect(page).to have_content "Membership Level is not included in the list"
end

Then /^I should get an error telling me to accept the terms$/ do
  expect(page).to have_content "Agreed to terms must be accepted"
end

When /^I should get an error telling my passwords don't match$/ do
  expect(page).to have_content "Password doesn't match confirmation"
end

Then /^my details should not be queued$/ do
  expect(Resque).to_not receive(:enqueue)
end

Then /^a welcome email should be sent to me$/ do
  steps %Q{
    Then "#{@email}" should receive an email
    When they open the email
    And they should see the email delivered from "members@theodi.org"
    And they should see "Welcome to the ODI network!" in the email subject
    And they should see "Your membership number is <strong>#{@membership_number}</strong>" in the email body
    And they should see "mailto:members@theodi.org" in the email body
  }
end

And (/^my organisation name is "(.*?)"$/) do |org_name|
  @organization_name = org_name
  fill_in('member_organization_name', :with => @organization_name)
end

And (/^my organisation name is expected to be "(.*?)"$/) do |org_name|
  @organization_name = org_name
end

Then (/^my organisation name should be "(.*?)"$/) do |org_name|
  @member.organization.name.should == org_name
end

Then(/^I should see today's date$/) do
  page.body.should include(Date.today.to_formatted_s(:long_ordinal))
end

When(/^I choose to pay by invoice$/) do
  choose('Annual invoice')
  @payment_method = 'invoice'
end
