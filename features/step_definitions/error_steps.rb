When(/^I request a page that doesn't exist$/) do
  visit("/foobar")
end

Then(/^I should see a helpful error page$/) do
  expect(page).to have_content 'Page not found'   
  expect(page).to have_content 'sign in'
end

Then(/^the response status should be "(.*?)"$/) do |status|
  expect(page.status_code).to eq(status.to_i)
end
