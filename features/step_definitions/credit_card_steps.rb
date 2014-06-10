When(/^I choose to pay by credit card$/) do
  choose("Credit Card")
  @payment_method = "credit_card"
end

When(/^I enter valid credit card details$/) do
  fill_in 'Card number', with: '4242424242424242'
  fill_in 'Card validation code', with: '123'
  fill_in 'Card expiry month', with: "12"
  fill_in 'Card expiry year', with: "2016"
  @paid = true
end

Then(/^my card should be charged successfully$/) do
  member = Member.find_by_email(@email)
  member.stripe_customer.subscriptions.total_count.should == 1
end

When(/^I enter invalid credit card details$/) do
  fill_in 'Card number', with: '4242424242424241'
  fill_in 'Card validation code', with: '123'
  fill_in 'Card expiry month', with: "12"
  fill_in 'Card expiry year', with: "2016"
end

Then(/^my card should not be charged$/) do
  member = Member.find_by_email(@email)
  member.stripe_customer_id.should be_nil
end
