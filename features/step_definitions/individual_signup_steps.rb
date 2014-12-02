Given(/^I want to sign up as an individual member$/) do
  @product_name = 'individual'
end

Then(/^I should not see the "(.*?)" field$/) do |field|
  assert has_no_field?(field)
end

Then(/^the terms and conditions should be correct$/) do
  (page).should have_content("an 'Individual' Supporter of the ODI.")
end
