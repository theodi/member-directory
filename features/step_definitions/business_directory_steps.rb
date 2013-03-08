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
  page.should have_content 'Edit your organisation profile' 
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
  @organization_name = "FooBar Inc"
  @organization_description = "We're the best!"
  @organization_url = "http://www.foo.bar"
  
  fill_in('organization_name',         :with => @organization_name)
  fill_in('organization_description',  :with => @organization_description)
  fill_in('organization_url',          :with => @organization_url)
end

Then /^I leave my organization (.*?) blank$/ do |field|
  fill_in("organization_#{field}", :with => nil)
end

When /^I click submit$/ do
  click_button('Submit')
end

Then /^I should see a preview page$/ do
  page.should have_content 'See below to see how your profile will look in our directory.'
end

Then /^I should see a notice saying my submission has been added$/ do
  page.should have_content 'Your submission has been added.'
end

Then /^I click edit$/ do
  click_button('Edit')
end

Then /^I should be able to edit my details$/ do
  page.should have_content 'Edit your organisation profile'
end

Then /^I edit my details$/ do
  @changed_organization_name = "FooBar Incorporated"
  @changed_organization_description = "We really are the best!"
  @changed_organization_url = "http://www.foo.bar/contact"  

  fill_in('organization_name',         :with => @changed_organization_name)
  fill_in('organization_description',  :with => @changed_organization_description)
  fill_in('organization_url',          :with => @changed_organization_url)
end

Then /^I should see my changed details on the preview page$/ do
  page.should have_content @changed_organization_name
  page.should have_content @changed_organization_description
  page.find(:xpath, '/html/body/div/section/ul/li/a')[:href].should include @changed_organization_url
end

Then /^my description is (\d+) characters long$/ do |length|
  fill_in('organization_description',  :with => (0...length.to_i).map{ ('a'..'z').to_a[rand(26)] }.join)
end

When /^I should see an error telling me that my description should not be longer than (\d+) characters$/ do |characters|
  page.should have_content "Your description cannot be longer than #{characters} characters"
end