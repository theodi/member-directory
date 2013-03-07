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
  @organization_email = "foo@bar.com"
  @organization_url = "http://www.foo.bar"
  
  fill_in('organization_name',         :with => @organization_name)
  fill_in('organization_description',  :with => @organization_description)
  fill_in('organization_email',        :with => @organization_email)
  fill_in('organization_url',          :with => @organization_url)
end

Then /^I leave my organization (.*?) blank$/ do |field|
  fill_in("organization_#{field}", :with => nil)
end

When /^I click submit$/ do
  click_button('Submit')
end

Then /^my details should be updated in CapsuleCRM$/ do
  # We don't have this code yet!
end

Then /^my details should not be updated in CapsuleCRM$/ do
  # We don't have this code yet!
end

Then /^my description is (\d+) characters long$/ do |length|
  fill_in('organization_description',  :with => (0...length.to_i).map{ ('a'..'z').to_a[rand(26)] }.join)
end

When /^I should see an error telling me that my description should not be longer than (\d+) characters$/ do |characters|
  page.should have_content "Your description cannot be longer than #{characters} characters"
end