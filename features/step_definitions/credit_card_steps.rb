When(/^I choose to pay by credit card$/) do
  choose("Credit Card")
end

When(/^I enter my credit card details$/) do
  fill_in 'Card number', with: '4242424242424242'
  fill_in 'Card validation code', with: '123'
  fill_in 'Card expiry month', with: "12"
  fill_in 'Card expiry year', with: "2016"
end

Then(/^my card should be charged successfully$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^my queued details should state that I have paid$/) do
  puts "TODO!"
end
