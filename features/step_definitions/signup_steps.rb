Given /^that I want to sign up as a (\w*)$/ do |product_name|
  @product_name = product_name # Required
end

Given(/^that I want to sign up as an individual supporter$/) do
  @product_name = "individual"
end

Given /^product information has been setup for "(.*?)"$/ do |plan|
  @chargify_product_url = "http://test.host/product/#{plan}"
  @chargify_product_price = 800
  @coupon = double(:code => "ODIALUMNI", :percentage => 50)
  Member.register_chargify_product_price(plan, @chargify_product_price*100)
  Member.register_chargify_coupon_code(@coupon)
end

Given /^the student coupon code SUPERFREE is in Chargify$/ do
  @chargify_product_url = "http://test.host/product/individual-supporter-student"
  @chargify_product_price = 800
  @coupon = double(:code => "SUPERFREE", :percentage => 100)
  Member.register_chargify_product_price("individual-supporter-student", @chargify_product_price*100)
  Member.register_chargify_coupon_code(@coupon)
end

Given /^there is already an organization with the name I want to use$/ do
  FactoryGirl.create :member, :organization_name => 'FooBar Inc'
end

Given /^there is already an organization with the name '(.*?)'$/ do |org_name|
  FactoryGirl.create :member, :organization_name => org_name
end

Given(/^a sponsor account already exists$/) do
  @password = 'password'
  @email = Faker::Internet.email
  @member = FactoryGirl.build(:member,
    :product_name          => "supporter",
    :organization_name     => Faker::Company.name,
    :password              => @password,
    :password_confirmation => @password,
    :email                 => @email
  )

  @member.save!
  @member.current!
end

Given(/^I have a (sponsor|partner) account$/) do |level|
  @password = 'password'
  @email = Faker::Internet.email
  @member = FactoryGirl.build :member, :product_name => level, :organization_name => Faker::Company.name,
                         :password => @password, :password_confirmation => @password, :email => @email
  @member.remote!
  @member.save!
  @member.current!
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

Given(/^I visit their account page$/) do
  visit member_path(@member)
end

When /^I visit the signup page$/ do
  visit("/members/new?level=#{@product_name}")
  expect(page).to have_content 'Become an ODI member'
  @field_prefix = 'member'
end

When(/^I visit the signup page with the invoice flag set$/) do
  visit("/members/new?level=#{@product_name}&invoice=true")
  expect(page).to have_content 'Become an ODI member'
  @field_prefix = 'member'
  @payment_method = 'invoice'
  @coupon = double(code: nil)
end

When(/^I visit the signup page with an origin of "(.*?)"$/) do |origin|
  @origin = origin
  visit("/members/new?level=#{@product_name}&origin=#{origin}")
end

When(/^I visit the signup page with a coupon of "(.*?)"$/) do |coupon|
  visit("/members/new?level=#{@product_name}&coupon=#{coupon}")
end

When /^I enter my name and contact details$/ do
  @contact_name = 'Ian McIain'
  @email ||= 'iain@foobar.com'
  @telephone = '0121 123 446'
  @share_with_third_parties = false
  @twitter = nil
  # @coupon_code ||= @coupon.code

  fill_in('member_contact_name', :with => @contact_name)
  fill_in('member_email', :with => @email)
  fill_in('member_telephone', :with => @telephone)

  fill_in('member_password', :with => @password || 'p4ssw0rd')
  fill_in('member_password_confirmation', :with => @password || 'p4ssw0rd')
end

When /^I enter my address details$/ do
  @street_address = '123 Fake Street'
  @address_region = 'Faketown'
  @address_country = 'United Kingdom'
  @postal_code = 'FAKE 123'

  fill_in('member_street_address', :with => @street_address)
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
end

When /^I enter my non-profit organization details$/ do
  @organization_name = 'FooBar Inc'
  @organization_size = '10-50'
  @organization_type = 'non_commercial'
  @organization_sector = 'Media'
  @organization_vat_id = '413444343'
  @organization_company_number = '087654321'

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
  @payment_method ||= 'credit_card'
  click_button('submit')
end

When /^I click pay now$/ do
  click_button('Pay now')
end

When /^I click complete$/ do
  click_button('Complete')
end

Then /^I am redirected to the payment page$/ do
  member = Member.find_by_email(@email)
  expect(current_path).to eq(payment_member_path(member))
end

Then /^I ?am returned to the thanks page$/ do
  member = Member.find_by_email(@email)
  expect(current_path).to eq(thanks_member_path(member))
end

Then /^there are payment frequency options$/ do
  expect(page).to have_css("input[type=radio][id=payment_frequency_monthly][value=monthly]")
  expect(page).to have_css("input[type=radio][id=payment_frequency_annual][value=annual]")
end

Then /^I choose to pay "(.*?)"$/ do |option|
  choose(option)
end

Then /^I am processed through chargify for the "(.*?)" option$/ do |plan|
  # hack to pretend we've gone via chargify and back
  member = Member.find_by_email(@email)
  @payment_ref = "3"
  params = {
    reference: member.membership_number,
    subscription_id: "1",
    customer_id: "2",
    payment_id: @payment_ref
  }

  # This is terrible, obviously, but needs must
  allow(ChargifyProductLink).to receive(:for).and_return(chargify_return_members_path(params))
end

Then(/^the coupon code "(.*?)" is saved against my membership$/) do |coupon|
  @discount = 50
  member = Member.find_by_email(@email)
  expect(member.coupon).to eq(coupon)
end

When(/^chargify verifies the payment$/) do
  member = Member.find_by_email(@email)
  MembersController.skip_before_filter :verify_chargify_webhook
  post chargify_verify_members_path, event: 'signup_success', payload: {
    subscription: {
      id: 1,
      signup_payment_id: @payment_ref,
      customer: {
        id: 2,
        reference: member.membership_number
      },
      coupon_code: @coupon.code
    }
  }
end

Then /^my organization should be made active in Capsule$/ do
  expect(Resque).to receive(:enqueue) do |*args|
    expect(args[0]).to eql SendDirectoryEntryToCapsule
    expect(args[3][:active]).to eq(true)
  end
end

Then /^(their|my) details should be queued for further processing$/ do |ignore|
  organization = {
    'name' => @organization_name,
    'vat_id' => @organization_vat_id,
    'company_number' => @organization_company_number,
    'size' => @organization_size,
    'type' => @organization_type,
    'sector' => @organization_sector,
    'origin' => @origin,
    'newsletter' => true,
    'share_with_third_parties' => @share_with_third_parties
  }

  contact_person = {
    'name'                           => @contact_name,
    'email'                          => @email,
    'telephone'                      => @telephone,
    'twitter'                        => @twitter,
    'dob'                            => @dob,
    'country'                        => @address_country,
    'university_email'               => @university_email,
    'university_address_country'     => @university_address_country,
    'university_country'             => @university_country,
    'university_name'                => @university_name,
    'university_name_other'          => @university_name_other,
    'university_course_name'         => @university_course_name,
    'university_qualification'       => @university_qualification,
    'university_qualification_other' => @university_qualification_other,
    'university_course_start_date'   => @university_course_start_date,
    'university_course_end_date'     => @university_course_end_date
  }

  billing = {
    'name' => @contact_name,
    'email' => @email,
    'telephone' => @telephone,
    'address' => {
      'street_address' => @street_address,
      'address_locality' => @address_locality,
      'address_region' => @address_region,
      'address_country' => @address_country,
      'postal_code' => @postal_code
    },
    'coupon' => @coupon ? @coupon.code : nil
  }

  purchase = {
    'discount' => @discount
  }

  expect(Resque).to receive(:enqueue) do |*args|
    expect(args[0]).to eql SignupProcessor
    expect(args[1]).to eql organization
    expect(args[2]).to eql contact_person
    expect(args[3]).to eql billing
    expect(args[4]['payment_method']).to eql @payment_method
    expect(args[4]['payment_ref']).to eql @payment_ref
    expect(args[4]['offer_category']).to eql @product_name
    expect(args[4]['membership_id']).not_to eql nil
    expect(args[4]['amount_paid']).to eq(@amount)
  end
end

And /^(I|they) should have a membership number generated$/ do |ignore|
  @member = Member.find_by_email(@email)
  @membership_number = @member.membership_number
  expect(@membership_number).to_not be_nil
  expect(@membership_number).to match(/[A-Z]{2}[0-9]{4}[A-Z]{2}/)
end

Then /^I should see an error relating to (.*)$/ do |text|
  expect(page.find(:css, "div.alert-error")).to have_content(text)
end

Then /^I should not see an error$/ do
  expect(page).to_not have_css("div.alert-error")
end

Then /^I should get an error telling me to accept the terms$/ do
  expect(page).to have_content "Agreed to terms must be accepted"
end

When /^I should get an error telling my passwords don't match$/ do
  expect(page).to have_content "Password doesn't match confirmation"
end

Then /^a welcome email should be sent to me$/ do
  steps %Q{
    Then a welcome email should be sent to "#{@email}"
  }
end

Then(/^a welcome email should be sent to "(.*?)"$/) do |email|
  steps %Q{
    Then "#{email}" should receive an email
    When they open the email
    And they should see the email delivered from "members@theodi.org"
    And they should see "mailto:members@theodi.org" in the email body
  }
  expect(current_email).to bcc_to(%w(members@theodi.org))
end

Then(/^I should have an origin of "(.*?)"$/) do |origin|
  member = Member.find_by_email(@email)
  expect(member.origin).to eq(origin)
end

Given(/^I have signed up, but haven't paid$/) do
  steps %{
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    And I click sign up
  }
end

Given(/^I try to sign up again$/) do
  steps %{
    Given that I want to sign up as a supporter
    And product information has been setup for "corporate-supporter_annual"
    When I visit the signup page
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    And I click sign up
  }
end


Given(/^there is an abandoned account with the email "(.*?)" and the password "(.*?)"$/) do |email, password|
  @email = email
  @password = password
  @original_password = password
  steps %{
    When I visit the signup page
    And I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    And I click sign up
  }
  @membership_number = Member.last.membership_number
end

Given(/^I try to sign up with the email "(.*?)" and the password "(.*?)"$/) do |email, password|
  @email = email
  @password = password
  steps %{
    When I visit the signup page
    And I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
  }
end

Then(/^I should be redirected to the login page$/) do
  expect(current_path).to eq(new_member_session_path)
end

Then(/^I should see an error telling me I need to login$/) do
  expect(page.body).to include("You have already started the signup process, to continue to payment, please login.")
end

Then(/^I log in$/) do
  fill_in('member_password', :with => @original_password)
  click_button('submit')
end

Then(/^the signup page should have a hidden field called "(.*?)"$/) do |name|
  expect(page).to have_selector("input[name='member[#{name}]']")
  @field = page.find("input[name='member[#{name}]']")
end

Then(/^the hidden field should have the value "(.*?)"$/) do |value|
  expect(@field.value).to eq(value)
end

Then(/^(I|they) should be marked as active$/) do |ignore|
  expect(@member.cached_active).to eq(true) if @member.organization?
  expect(@member.current).to eq(true)
end

Then(/^I should see an affiliated node section$/) do
  expect(page.body).to include("Are you affiliated with an ODI Node?")
  expect(page).to have_selector("select[name='member[origin]']")
end

Then(/^the dropdown should be pre\-selected with "(.*?)"$/) do |origin|
  field = page.find("select[name='member[origin]']")
  expect(field.value).to eq(origin)
end

Then(/^if I navigate away and then return$/) do
  visit "/members" # path is not relevant, just away from the signup page
  visit("/members/new?level=#{@product_name}")
end

Then(/^the original origin value should be still be "(.*?)"$/) do |origin|
  field = page.find("select[name='member[origin]']")
  expect(field.value).to eq(origin)
end

Then(/^I realise that I want to pay by invoice$/) do
  expect(page.find(".pay-by-invoice").text).to eq("Or would you rather pay by invoice?")
end

Then(/^I follow the pay by invoice link$/) do
  # Member has been sent the invoice URL by us
  visit("/members/new?level=#{@product_name}&invoice=true")
end

Then(/^an? (.*?) membership should be created for "(.*?)"$/) do |product_name, email|
  @member = Member.where(email: email).first
  expect(@member).to be_present
  expect(@member.product_name).to eql product_name
  @email = email
  steps %Q{
    Then they should have a membership number generated
    Then they should be marked as active
  }
end

Then(/^that member should be set up in Chargify$/) do
  expect(@member.chargify_subscription_id).to be_present
end

When(/^I visit the signup page with an coupon code of "(.*?)"$/) do |coupon_code|
  @coupon_code = coupon_code
  visit("/members/new?level=#{@product_name}&coupon=#{@coupon_code}")
end

Then(/^I should not see the subscription amount$/) do
  expect(page).to_not have_text("Annual subscription amount")
end
