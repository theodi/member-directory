Given(/^I want to sign up as an individual member$/) do
  @product_name = 'individual'
  @payment_method = 'credit_card'
  @payment_ref = /cus_[0-9A-Za-z]{14}/
end

Given(/^I sign up as an indidual member$/) do
  steps %{
    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my details
    And I enter valid credit card details
  }
end

Then(/^I should not have an organisation assinged to me$/) do
  member = Member.where(email: @email).first
  (member.organization).should be_nil
end

Then(/^I should not see the "(.*?)" field$/) do |field|
  assert has_no_field?(field)
end

Then(/the submit button should say "(.*?)"$/) do |text|
  expect(page).to have_selector("input[type=submit][value='#{text}']")
end

Then(/^the terms and conditions should be correct$/) do
  expect(page).to have_content("You agree to comply with these terms and conditions")
end

Then /^my individual details should be queued for further processing$/ do

  contact_person = {
    'name'      => @contact_name,
    'email'     => @email,
    'telephone' => @telephone
  }
  billing        = {
    'name'           => @contact_name,
    'email'          => @email,
    'telephone'      => @telephone,
    'address'        => {
      'street_address'   => @street_address,
      'address_locality' => @address_locality,
      'address_region'   => @address_region,
      'address_country'  => @address_country,
      'postal_code'      => @postal_code
    }
  }

  Resque.should_receive(:enqueue).with do |*args|
    args[0].should == SignupProcessor
    args[1].should == nil
    args[2].should == contact_person
    args[3].should == billing
    args[4]['payment_method'].should == @payment_method
    args[4]['payment_freq'].should == @payment_frequency
    args[4]['payment_ref'].should =~ @payment_ref if @payment_ref
    args[4]['offer_category'].should == @product_name
    args[4]['membership_id'].should_not be_nil
    args[4]['purchase_order_reference'].should == @purchase_order_number
  end
end

Then /^I should see my details$/ do
  page.should have_field('member_contact_name', with: @contact_name) 
  page.should have_field('member_email', with: @email) 
  page.should have_field('member_telephone', with: @telephone) 
end

Then /^I should see a link to the right to cancel$/ do
  expect(find_link("right to cancel")).to be_visible
end
