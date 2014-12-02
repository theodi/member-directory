Given(/^I want to sign up as an individual member$/) do
  @product_name = 'individual'
end

Then(/^I should not see the "(.*?)" field$/) do |field|
  assert has_no_field?(field)
end

Then(/^I should not have to option to pay by invoice$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the terms and conditions should be correct$/) do
  pending # express the regexp above with the code you wish you had
end
