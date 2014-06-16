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

When(/^I choose to pay on a monthly basis$/) do
  select "Monthly", from: "Payment frequency"
  @payment_frequency = :monthly
end

When(/^I choose to pay on an? annual basis$/) do
  select "Yearly", from: "Payment frequency"
  @payment_frequency = :annual
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
  customer = member.stripe_customer
  customer.description.should =~ /(#{member.organization.name})/
  customer.description.should =~ /supporter/
  customer.description.should =~ /membership \([A-Z]{2}[0-9]{4}[A-Z]{2}\)/
  customer.subscriptions.total_count.should == 1
end

Then(/^my card should not be charged$/) do
  member = Member.find_by_email(@email)
  member.stripe_customer_id.should be_nil
end

When(/^I enter an organisation size of (.+)$/) do |size|
  @organization_size = size
  select(find_by_id('member_organization_size').find("option[value='#{@organization_size}']").text, :from => 'member_organization_size')
end

When(/^I enter an organisation type of (.+)$/) do |type|
  @organization_type = type
  select(find_by_id('member_organization_type').find("option[value='#{@organization_type}']").text, :from => 'member_organization_type')
end

Then(/^I should be signed up to the (.+) plan$/) do |plan|
  member = Member.find_by_email(@email)
  member.stripe_customer.subscriptions.total_count.should == 1
  member.stripe_customer.subscriptions["data"][0]["plan"].id.should == plan
end

Then(/^credit card payment shouldn't be attempted$/) do
  Stripe::Customer.should_not receive(:create)
end
