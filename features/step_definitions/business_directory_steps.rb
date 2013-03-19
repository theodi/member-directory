Given /^that I have signed up$/ do
  steps %Q{
    Given that I want to sign up
		When I visit the signup page
		And I enter my details
		And I click sign up
  }
end

Given /^that I have signed up as a (\w*)$/ do |product_name|
  steps %Q{
    Given that I want to sign up as a #{product_name}
		When I visit the signup page
		And I enter my details
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
  
  fill_in('member_organization_attributes_name',         :with => @organization_name)
  fill_in('member_organization_attributes_description',  :with => @organization_description)
  fill_in('member_organization_attributes_url',          :with => @organization_url)
  fill_in('member_organization_attributes_contact',      :with => @organization_contact)
  fill_in('member_organization_attributes_phone',        :with => @organization_phone)
  fill_in('member_organization_attributes_email',        :with => @organization_email)
  fill_in('member_organization_attributes_twitter',      :with => @organization_twitter)
  fill_in('member_organization_attributes_linkedin',     :with => @organization_linkedin)
  fill_in('member_organization_attributes_facebook',     :with => @organization_facebook)
end

Then /^I attach an image$/ do
  @organization_logo = File.join(::Rails.root, "fixtures/image_object_uploader/acme-logo.png")
  
  # Store the urls for access earlier in the steps
  @fullsize_url = "#{ENV['RACKSPACE_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/original.png"
  @rectangular_url = "#{ENV['RACKSPACE_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/rectangular.png"
  @square_url = "#{ENV['RACKSPACE_ASSET_HOST']}/logos/<MEMBERSHIP_NUMBER>/square.png"
  
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
  Timecop.freeze
  fill_in("member_current_password", :with => 'p4ssw0rd')
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

  fill_in('member_organization_attributes_name',         :with => @changed_organization_name)
  fill_in('member_organization_attributes_description',  :with => @changed_organization_description)
  fill_in('member_organization_attributes_url',          :with => @changed_organization_url)
  fill_in('member_organization_attributes_contact',      :with => @changed_organization_contact)
  fill_in('member_organization_attributes_phone',        :with => @changed_organization_phone)
  fill_in('member_organization_attributes_email',        :with => @changed_organization_email)
  fill_in('member_organization_attributes_twitter',      :with => @changed_organization_twitter)
  fill_in('member_organization_attributes_linkedin',     :with => @changed_organization_linkedin)
  fill_in('member_organization_attributes_facebook',     :with => @changed_organization_facebook)
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
  }
  
  date = @member.organization.updated_at.to_s
  
  Resque.should_receive(:enqueue).with(SendDirectoryEntryToCapsule, organization, directory_entry, date)
end

Then /^my organisation details should not be queued for further processing$/ do
  Resque.should_not_receive(:enqueue)
end