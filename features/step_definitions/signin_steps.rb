Given /^that I have a membership number and password$/ do
  # Create a new member
  member = Member.new(
    :product_name => 'supporter',
    :organization_name => 'FooBar Inc',
    :contact_name => 'Ian McIain',
    :email => 'iain@foobar.com',
    :telephone => '0121 123 446',
    :street_address => '123 Fake Street',
    :address_locality => 'Faketown',
    :address_region => 'Fakeshire',
    :address_country => 'United Kingdom',
    :postal_code => 'FAKE 123',
    :organization_name => "Test Org",
    :organization_size => "251-1000",
    :organization_type => "commercial",
    :organization_sector => "Energy",
    :organization_vat_id => '213244343',
    :password => 'p4ssw0rd',
    :password_confirmation => 'p4ssw0rd',
    :agreed_to_terms => '1')
  # Skip Capsule and Xero Callback
  member.remote!
  member.save!
  member.current!

  @membership_number = member.membership_number
  @password = 'p4ssw0rd'
  @email = 'iain@foobar.com'
end

When /^I visit the sign in page$/ do
  visit('/session/new')
  expect(page).to have_content 'Sign in'
end

When /^I enter my membership number and password$/ do
  fill_in('member_login', :with => @membership_number)
end

When /^I enter my email address and password$/ do
  fill_in('member_login', :with => @email)
end

And /^the password is correct$/ do
  fill_in('member_password', :with => @password)
end

When /^I click sign in$/ do
  click_button('submit')
end

Then /^I should have signed in successfully$/ do
  expect(page).to have_content "Signed in successfully"
end

And /^the password is incorrect$/ do
  fill_in('member_password', :with => 'Thisisnttherightpassword')
end

And /^the membership number is incorrect$/ do
  fill_in('member_login', :with => '42342342342342')
end

Then /^I should have recieve an error$/ do
  expect(page).to have_content "Invalid login or password"
end

Given(/^my size and sector are not set$/) do
  @membership.organization_size = nil
  @membership.organization_sector = nil
  @membership.save(validate: false)
end
