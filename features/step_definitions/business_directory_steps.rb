Given /^that I have signed up$/ do
  steps %Q{
    Given that I want to sign up
		When I visit the signup page
		And I enter my details
    And I choose to pay by invoice
		And I click sign up
  }
end

Given /^that I have signed up as a (\w*)$/ do |product_name|
  steps %Q{
    Given that I want to sign up as a #{product_name}
		When I visit the signup page
		And I enter my details
    And I choose to pay by invoice
		And I click sign up
  }
end

Then /^I am redirected to submit my organization details$/ do
  page.should have_content 'Edit your details'
end

Then /^I cannot see a logo upload$/ do
  page.should_not have_content 'Logo'
end

Then /^the description field is limited to (\d+) characters$/ do |limit|
  page.should have_content "Limit of #{limit} characters"
end

Then /^I can see a logo upload$/ do
  page.should have_content 'Logo'
end

Then /^I enter my organization details$/ do
  @organization_name        = Faker::Company.name
  @organization_description = Faker::Company.bs
  @organization_url         = Faker::Internet.url
  @organization_contact     = Faker::Name.name
  @organization_phone       = Faker::PhoneNumber.phone_number
  @organization_email       = Faker::Internet.email
  @organization_twitter     = Faker::Internet.user_name
  @organization_linkedin    = Faker::Internet.url
  @organization_facebook    = Faker::Internet.url
  @organization_tagline     = Faker::Company.bs

  fill_in('member_organization_attributes_name',                 :with => @organization_name)
  fill_in('member_organization_attributes_description',          :with => @organization_description)
  fill_in('member_organization_attributes_url',                  :with => @organization_url)
  fill_in('member_organization_attributes_cached_contact_name',  :with => @organization_contact)
  fill_in('member_organization_attributes_cached_contact_phone', :with => @organization_phone)
  fill_in('member_organization_attributes_cached_contact_email', :with => @organization_email)
  fill_in('member_organization_attributes_cached_twitter',       :with => @organization_twitter)
  fill_in('member_organization_attributes_cached_linkedin',      :with => @organization_linkedin)
  fill_in('member_organization_attributes_cached_facebook',      :with => @organization_facebook)
  fill_in('member_organization_attributes_cached_tagline',       :with => @organization_tagline)
end

Then /^I attach an image$/ do
  @organization_logo = File.join(::Rails.root, "fixtures/image_object_uploader/acme-logo.png")

  # Store the urls for access earlier in the steps
  @fullsize_url = "#{ENV['RACKSPACE_DIRECTORY_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/original.png"
  @rectangular_url = "#{ENV['RACKSPACE_DIRECTORY_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/rectangular.png"
  @square_url = "#{ENV['RACKSPACE_DIRECTORY_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/square.png"

  attach_file('member_organization_attributes_logo', @organization_logo)
end

Then /^I enter the URL (.*?)$/ do |url|
  @organization_url = url
  fill_in('member_organization_attributes_url',          :with => @organization_url)
end

Then /^I leave my organization (.*?) blank$/ do |field|
  fill_in("member_organization_attributes_#{field}", :with => nil)
end

Then /^I enter the organization name '(.*?)'$/ do |org_name|
  fill_in("member_organization_attributes_name", :with => org_name)
end

When /^I click submit$/ do
  fill_in("member_current_password", :with => @password || 'p4ssw0rd')
  click_button('Save')
end

Then /^I should see a notice that my details were saved successfully$/ do
  page.should have_content 'You updated your account successfully.'
end

Then /^I edit my details$/ do
  @changed_organization_name        = Faker::Company.name
  @changed_organization_description = Faker::Company.bs
  @changed_organization_url         = Faker::Internet.url
  @changed_organization_contact     = Faker::Name.name
  @changed_organization_phone       = Faker::PhoneNumber.phone_number
  @changed_organization_email       = Faker::Internet.email
  @changed_organization_twitter     = Faker::Internet.user_name
  @changed_organization_linkedin    = Faker::Internet.url
  @changed_organization_facebook    = Faker::Internet.url
  @changed_organization_tagline     = Faker::Company.bs

  fill_in('member_organization_attributes_name',                 :with => @changed_organization_name)
  fill_in('member_organization_attributes_description',          :with => @changed_organization_description)
  fill_in('member_organization_attributes_url',                  :with => @changed_organization_url)
  fill_in('member_organization_attributes_cached_contact_name',  :with => @changed_organization_contact)
  fill_in('member_organization_attributes_cached_contact_phone', :with => @changed_organization_phone)
  fill_in('member_organization_attributes_cached_contact_email', :with => @changed_organization_email)
  fill_in('member_organization_attributes_cached_twitter',       :with => @changed_organization_twitter)
  fill_in('member_organization_attributes_cached_linkedin',      :with => @changed_organization_linkedin)
  fill_in('member_organization_attributes_cached_facebook',      :with => @changed_organization_facebook)
  fill_in('member_organization_attributes_cached_tagline',       :with => @changed_organization_tagline)
end

Then /^I should see my changed details when I revisit the edit page$/ do
  click_link('My Account')
  page.should have_content @changed_organization_name
  page.should have_content @changed_organization_description
  page.should have_content @changed_organization_url
  page.should have_content @changed_organization_contact
  page.should have_content @changed_organization_phone
  page.should have_content @changed_organization_email
  page.should have_content @changed_organization_twitter
  page.should have_content @changed_organization_linkedin
  page.should have_content @changed_organization_facebook
  page.should have_content @changed_organization_tagline
  page.find('#member_cached_newsletter').checked?.should == @newsletter
end

Then /^my description is (\d+) characters long$/ do |length|
  fill_in('member_organization_attributes_description',  :with => (0...length.to_i).map{ ('a'..'z').to_a[rand(26)] }.join)
end

When /^I should see an error telling me that my description should not be longer than (\d+) characters$/ do |characters|
  page.should have_content "Your description cannot be longer than #{characters} characters"
end

Then /^the fullsize logo should be available at the correct URL$/ do
  @member = Member.find_by_email(@email)
  @member.organization.logo.url.should eq @fullsize_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number)
end

Then /^the rectangular logo should be available at the correct URL$/ do
  @member.organization.logo.rectangular.url.should eq @rectangular_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number)
end

Then /^the square logo should be available at the correct URL$/ do
  @member.organization.logo.square.url.should eq @square_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number)
end

Then /^my organisation details should be queued for further processing$/ do
  @member = Member.find_by_email(@email)

  logo = @fullsize_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number) rescue nil
  thumbnail = @square_url.gsub(/<MEMBERSHIP_NUMBER>/, @member.membership_number) rescue nil

  organization = {
    :name => @organization_name
  }

  directory_entry = {
    :description => @organization_description,
    :homepage    => @organization_url,
    :logo        => logo,
    :thumbnail   => thumbnail,
    :contact     => @organization_contact,
    :phone       => @organization_phone,
    :email       => @organization_email,
    :twitter     => @organization_twitter,
    :linkedin    => @organization_linkedin,
    :facebook    => @organization_facebook,
    :tagline     => @organization_tagline,
  }

  date = @member.organization.updated_at.to_s

  Resque.should_receive(:enqueue).with(SendDirectoryEntryToCapsule, @member.membership_number, organization, directory_entry, date)
end

Then /^my organisation details should not be queued for further processing$/ do
  Resque.should_not_receive(:enqueue)
end

Then(/^I update my membership details$/) do
  @changed_email      = Faker::Internet.email
  @changed_newsletter = true

  fill_in('member_email', :with => @changed_email)
  if @changed_newsletter
    check('member_cached_newsletter')
  else
    uncheck('member_cached_newsletter')
  end
  
  @changed_size = ">1000"
  select("more than 1000", :from => "member_organization_size")

  @changed_sector = "Other"
  select(@changed_sector, :from => "member_organization_sector")
  
end

Then(/^my membership details should be queued for updating in CapsuleCRM$/) do
  @member = Member.find_by_email(@email)
  Resque.should_receive(:enqueue).with(SaveMembershipDetailsToCapsule, @member.membership_number, {
    'email'      => @changed_email,
    'newsletter' => @changed_newsletter,
    'size'       => @changed_size,
    'sector'     => @changed_sector,
  })
end

When(/^I should see my changed membership details when I revisit the edit page$/) do
  page.should have_content(@changed_email)
  (page.find('#member_cached_newsletter').checked? == 'checked').should == @changed_newsletter
  page.find('#member_organization_size').value.should == @changed_size
  page.find('#member_organization_sector').value.should == @changed_sector
end

Given(/^there are (\d+) active partners in the directory$/) do |num|
  num.to_i.times do
    member = FactoryGirl.create :member, :product_name => 'partner', :cached_active => true
    member.organization.description = Faker::Company.catch_phrase
    member.organization.save
  end
end

Given(/^I am a founding partner$/) do
  @member = Member.find_by_email(@email)
  @member.membership_number = ENV['FOUNDING_PARTNER_ID']
  @member.save
end

When(/^I visit the members list$/) do
  visit("/members")
end

Then(/^I should be listed as a founding partner$/) do
  all("h2").first.text.should match /Founding partner/
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
  @member.cached_active = true
  @member.save
end

Then(/^my listing should appear first in the list$/) do
  all("h2").count.should == 6
  all("h2").first.text.should match /#{@organization_name}/
end
