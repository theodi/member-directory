Given(/^I want to sign up as an individual member$/) do
  @product_name = 'individual'
  @payment_method = 'credit_card'
  @payment_ref = /cus_[0-9A-Za-z]{14}/
end

When(/^I enter my subscription amount$/) do
  @amount = 5
  select(@amount, from: 'member_subscription_amount')
end

Then(/^I should not have an organisation assigned to me$/) do
  member = Member.where(email: @email).first
  expect(member.organization).to be_nil
end

Then(/^I should not see the "(.*?)" field$/) do |field|
  assert has_no_field?(field)
end

Then(/the submit button should say "(.*?)"$/) do |text|
  expect(page).to have_selector("input[type=submit][value='#{text}']")
end

Then(/^the terms and conditions should be correct$/) do
  expect(page).to have_content("Your category of membership is “individual member”")
end

Then /^I should see a link to the right to cancel$/ do
  expect(find_link("right to cancel")).to be_visible
end

Then(/^I should not see the student specific fields$/) do
  expect(page).to_not have_content("University Details")
end
