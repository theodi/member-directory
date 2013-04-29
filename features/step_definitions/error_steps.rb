When(/^I request a page that doesn't exist$/) do
  visit("/foobar")
end

Then(/^I should see a helpful error page$/) do
  page.should have_content 'Page not found'   
  page.should have_content 'sign in'
end

Then(/^the response status should be "(.*?)"$/) do |status|
  page.status_code.should == status.to_i
end