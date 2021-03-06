Given /^that I have signed up$/ do
  steps %Q{
    Given that I have signed up as a supporter
  }
end

Given /^that I have signed up as a (\w*)$/ do |product_name|
  @email = 'iain@foobar.com'
  @member = Member.new(
    :product_name => product_name,
    :organization_name => 'FooBar Inc',
    :contact_name => 'Ian McIain',
    :email => @email,
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
    :password => 'p4ssw0rd',
    :password_confirmation => 'p4ssw0rd',
    :agreed_to_terms => '1')
  # Skip Capsule and Xero Callback
  @member.remote!
  @member.save!
  @member.current!

  @membership_number = @member.membership_number
  @password = 'p4ssw0rd'

  steps %Q{
    When I visit the sign in page
    And I enter my membership number and password
    And the password is correct
    When I click sign in
  }
end

Then /^I am redirected to submit my organization details$/ do
  expect(page).to have_content 'Edit your details'
end

Then /^I cannot see a logo upload$/ do
  expect(page).to_not have_content 'Logo'
end

Then /^I can see a logo upload$/ do
  expect(page).to have_content 'Logo'
end

Then /^I enter my organization details$/ do
  @organization_name        = Faker::Company.name
  @organization_description = Faker::Company.bs
  @organization_url         = "iaintgotnohttp.com"
  @organization_contact     = Faker::Name.name
  @organization_phone       = Faker::PhoneNumber.phone_number
  @organization_email       = Faker::Internet.email
  @organization_twitter     = Faker::Internet.user_name
  @organization_linkedin    = Faker::Internet.url
  @organization_facebook    = Faker::Internet.url
  @organization_tagline     = Faker::Company.bs

  fill_in('member_organization_name',                 :with => @organization_name)
  fill_in('member_organization_description',          :with => @organization_description)
  fill_in('member_organization_url',                  :with => @organization_url)
  fill_in('member_organization_contact_name',  :with => @organization_contact)
  fill_in('member_organization_contact_phone', :with => @organization_phone)
  fill_in('member_organization_contact_email', :with => @organization_email)
  fill_in('member_organization_twitter',       :with => @organization_twitter)
  fill_in('member_organization_linkedin',      :with => @organization_linkedin)
  fill_in('member_organization_facebook',      :with => @organization_facebook)
  fill_in('member_organization_tagline',       :with => @organization_tagline)
end

Then /^I attach an image$/ do
  @organization_logo = File.join(::Rails.root, "fixtures/image_object_uploader/acme-logo.png")

  # Store the urls for access earlier in the steps
  @fullsize_url = "#{ENV['RACKSPACE_DIRECTORY_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/original.png"
  @rectangular_url = "#{ENV['RACKSPACE_DIRECTORY_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/rectangular.png"
  @square_url = "#{ENV['RACKSPACE_DIRECTORY_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/square.png"

  attach_file('member_organization_logo', @organization_logo)
end

Then /^I enter the URL (.*?)$/ do |url|
  @organization_url = url
  fill_in('member_organization_url',          :with => @organization_url)
end

Then /^I leave my organization (.*?) blank$/ do |field|
  fill_in("member_organization_#{field}", :with => nil)
end

Then /^I enter the organization name '(.*?)'$/ do |org_name|
  fill_in("member_organization_name", :with => org_name)
end

When /^I click submit$/ do
  fill_in("member_current_password", :with => @password || 'p4ssw0rd')
  click_button('Save')
end

When /^I save their details$/ do
  click_button('Save')
end

Then /^I should see a notice that my details were saved successfully$/ do
  expect(page).to have_content 'You updated your account successfully.'
end

Then /^I should see a notice that the profile was saved successfully$/ do
  expect(page).to have_content 'Account updated successfully.'
end

Then /^I should see my changed details when I revisit the edit page$/ do
  first(:link, "My Account").click
  expect(page).to have_content @changed_organization_name
  expect(page).to have_content @changed_organization_description
  expect(page).to have_content @changed_organization_url
  expect(page).to have_content @changed_organization_contact
  expect(page).to have_content @changed_organization_phone
  expect(page).to have_content @changed_organization_email
  expect(page).to have_content @changed_organization_twitter
  expect(page).to have_content @changed_organization_linkedin
  expect(page).to have_content @changed_organization_facebook
  expect(page).to have_content @changed_organization_tagline
end

Then /^the fullsize logo should be available at the correct URL$/ do
  @member = Member.find_by_email(@email)
  expect(@member.organization_logo.url).to eq @fullsize_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number)
end

Then /^the rectangular logo should be available at the correct URL$/ do
  expect(@member.organization_logo.rectangular.url).to eq @rectangular_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number)
end

Then /^the square logo should be available at the correct URL$/ do
  expect(@member.organization_logo.square.url).to eq @square_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number)
end

Then(/^I update my membership details$/) do
  @changed_email      = Faker::Internet.email
  @changed_newsletter = true
  @changed_share_with_third_parties = true

  fill_in('member_email', :with => @changed_email)
  if @changed_newsletter
    check('member_newsletter')
  else
    uncheck('member_newsletter')
  end

  if @changed_share_with_third_parties
    check('member_share_with_third_parties')
  else
    uncheck('member_share_with_third_parties')
  end
  
  @changed_size = ">1000"
  select("more than 1000", :from => "member_organization_size")

  @changed_sector = "Other"
  select(@changed_sector, :from => "member_organization_sector")
  
end

When(/^I should see my changed membership details when I revisit the edit page$/) do
  #expect(page).to have_content(@changed_email)
  expect(page.find('#member_email').value).to eq @changed_email
  expect(page.find('#member_newsletter').checked?).to eq @changed_newsletter
  expect(page.find('#member_organization_size').value).to eq @changed_size
  expect(page.find('#member_organization_sector').value).to eq @changed_sector
end

Given(/^there are (\d+) active partners in the directory$/) do |num|
  num.to_i.times do
    member = FactoryGirl.create :current_active_member, :product_name => 'partner'
    member.organization_description = Faker::Company.catch_phrase
    member.save
  end
end

Given(/^I am a founding partner$/) do
  @member = Member.find_by_email(@email)
  @member.membership_number = ENV['FOUNDING_PARTNER_ID']
  @member.save validate: false
end

When(/^I visit the members list$/) do
  visit("/members")
end

Then(/^I should be listed as a founding partner$/) do
  expect(all("h2").first.text).to match /Founding partner/
end

Given(/^I have entered my organization details$/) do
  steps %{
    When I visit my account page
    And I am redirected to submit my organization details
    And I enter my organization details
    And I click submit
  }
end

Given(/^my listing is active$/) do
  @member.active = true
  @member.save
end

Then(/^my listing should appear first in the list$/) do
  expect(all("h2").count).to eq 6
  expect(all("h2").first.text).to match /#{@organization_name}/
end

Given(/^I am logged in as an administrator$/) do
  OmniAuth.config.test_mode = true
  hash = OmniAuth::AuthHash.new
  hash[:info] = { email: 'test@example.com' }
  OmniAuth.config.mock_auth[:google_oauth2] = hash
  visit admin_omniauth_authorize_path(:google_oauth2)
end

