When(/^I choose to pay by credit card$/) do
  choose("Credit Card")
  @payment_method = "credit_card"
end

When(/^I enter my card number (\d+)$/) do |number|
  fill_in 'Card number', with: number
end

When(/^I enter my CVC code (\d+)$/) do |cvc|
  fill_in 'Card validation code', with: cvc
end

When(/^I enter my expiry month (\d+)$/) do |month|
  fill_in 'Card expiry month', with: month
end

When(/^I enter my expiry year (\d+)$/) do |year|
  fill_in 'Card expiry year', with: year
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

Then(/^my card should not be charged$/) do
  member = Member.find_by_email(@email)
  member.stripe_customer_id.should be_nil
end
