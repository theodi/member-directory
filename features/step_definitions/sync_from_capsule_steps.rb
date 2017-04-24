Given /^I am not currently a member$/ do
end

Given /^I am not currently an individual member$/ do
  @product_name = "individual"
end

Given /^I am already signed up$/ do
  @membership = FactoryGirl.create :current_active_member
  @old_description = @membership.listing.description
end

Given(/^I am already signed up as an individual member$/) do
  @membership = FactoryGirl.create :current_active_individual_member
end

When /^I am set as a member in CapsuleCRM$/ do
  @active            = "true"
  @email             = Faker::Internet.email
  @product_name    ||= 'partner'
  @newsletter        = false
  @capsule_id        = 1234
end

When /^I am set as a member in CapsuleCRM without an email address$/ do
  @active            = "true"
  @email             = nil
  @product_name      = 'partner'
  @newsletter        = false
  @capsule_id        = 1234
end

When /^my information is changed in CapsuleCRM$/ do
  @capsule_id        = 1234
  @active            = "true"
  @email             = Faker::Internet.email
  @newsletter        = true
  @organization_name = Faker::Company.name
  @description       = Faker::Company.bs
  @url               = Faker::Internet.url
  @product_name      = 'sponsor'
  @membership_number = @membership.membership_number
  @contact_name      = Faker::Name.name
  @contact_phone     = Faker::PhoneNumber.phone_number
  @contact_email     = Faker::Internet.email
  @twitter           = Faker::Internet.url
  @linkedin          = Faker::Internet.url
  @facebook          = Faker::Internet.url
  @tagline           = Faker::Company.bs
  @organization_size = '>1000'
  @organization_sector = "Other"
end

When /^the sync task runs$/ do
  membership = {
    'email'         => @email,
    'product_name'  => @product_name,
    'id'            => @membership_number,
    'newsletter'    => @newsletter,
    'size'          => @organization_size,
    'sector'        => @organization_sector,
  }.compact
  directory_entry = {
    'active'        => @active,
    'name'          => @organization_name,
    'description'   => @description,
    'url'           => @url,
    'contact'       => @contact_name,
    'phone'         => @contact_phone,
    'email'         => @contact_email,
    'twitter'       => @twitter,
    'linkedin'      => @linkedin,
    'facebook'      => @facebook,
    'tagline'       => @tagline,
  }.compact
  CapsuleObserver.update(membership, directory_entry, @capsule_id)
end

When(/^the sync task runs it should raise an error$/) do
  membership = {
    'email'         => @email,
    'product_name'  => @product_name,
    'id'            => @membership_number,
    'newsletter'    => @newsletter,
    'size'          => @organization_size,
    'sector'        => @organization_sector,
  }.compact
  directory_entry = {
    'active'        => @active,
    'name'          => @organization_name,
    'description'   => @description,
    'url'           => @url,
    'contact'       => @contact_name,
    'phone'         => @contact_phone,
    'email'         => @contact_email,
    'twitter'       => @twitter,
    'linkedin'      => @linkedin,
    'facebook'      => @facebook,
    'tagline'       => @tagline,
  }.compact

  expect { CapsuleObserver.update(membership, directory_entry, @capsule_id) }.to raise_error
end

Then /^a membership should be created for me$/ do
  @membership = Member.where(:email => @email).first
  expect(@membership).to be_present
  @membership_number = @membership.membership_number
  expect(@membership_number).to be_present
  @old_description = @membership.listing.description
end

Then(/^an individual membership should be created for me$/) do
  @membership = Member.where(:email => @email).first
  expect(@membership).to be_present
  @membership_number = @membership.membership_number
  expect(@membership_number).to be_present
  expect(@membership.individual?).to eq(true)
end

Then(/^that membership should not be shown in the directory$/) do
  @active = false
  expect(@membership.active).to eq(@active)
end

Then /^my details should be cached correctly$/ do
  @membership = Member.where(membership_number: @membership_number).first
  expect(@membership.active).to                     eq (@active == "true")
  expect(@membership.product_name).to                      eq @product_name
  expect(@membership.newsletter).to                 eq @newsletter
  expect(@membership.organization_size).to                 eq @organization_size
  expect(@membership.organization_sector).to               eq @organization_sector
  expect(@membership.listing.name).to                 eq @organization_name
  expect(@membership.listing.description).to          eq @old_description # description should not change when synced
  expect(@membership.listing.url).to                  eq @url
  expect(@membership.listing.contact_name).to  eq @contact_name
  expect(@membership.listing.contact_phone).to eq @contact_phone
  expect(@membership.listing.contact_email).to eq @contact_email
  expect(@membership.listing.twitter).to       eq @twitter
  expect(@membership.listing.linkedin).to      eq @linkedin
  expect(@membership.listing.facebook).to      eq @facebook
  expect(@membership.listing.tagline).to       eq @tagline
end

Then(/^my individual details should be cached correctly$/) do
  @membership = Member.where(membership_number: @membership_number).first
  expect(@membership.active).to                     eq (@active == "true")
  expect(@membership.product_name).to                      eq @product_name
  expect(@membership.newsletter).to                 eq @newsletter
end

Then /^a warning email should be sent to the commercial team$/ do
  steps %Q(
    Then "members@theodi.org" should receive an email
    When they open the email
    And they should see "Membership creation failure" in the email subject
    And they should see "http://ukoditech.capsulecrm.com/party/#{@capsule_id}" in the email body
    And they should see the email delivered from "members@theodi.org"
  )
end
