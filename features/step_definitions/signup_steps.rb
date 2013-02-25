Given /^that I want to sign up as a (\w*)$/ do |level|
  @level = level # Required
end

Given /^that I want to sign up$/ do
  @level = 'supporter'
end

When /^I visit the signup page$/ do
  visit('/members/sign_up')
  page.should have_content 'Sign up'  
end

When /^I enter my details$/ do
  fill_in('member_level',                 :with => 'supporter')
  fill_in('member_contact_name',          :with => 'Ian McIain')
  fill_in('member_email',                 :with => 'iain@foobar.com')
  fill_in('member_organisation_name',     :with => 'FooBar Inc')
  fill_in('member_phone',                 :with => '0121 123 446')
  fill_in('member_address_line1',         :with => '123 Fake Street')
  fill_in('member_address_line2',         :with => 'Fake place')
  fill_in('member_address_city',          :with => 'Faketown')
  fill_in('member_address_region',        :with => 'Fakeshire')
  fill_in('member_address_country',       :with => 'UK')
  fill_in('member_address_postcode',      :with => 'FAKE 123')
  fill_in('member_tax_number',            :with => '213244343')
  fill_in('member_purchase_order_number', :with => 'PO-43243242342')

  check('member_agreed_to_terms')
  
end

When /^I leave (\w*) blank$/ do |field|
  fill_in("member_#{field}", :with => nil)
end

When /^I don't agree to the terms$/ do
  uncheck('member_agreed_to_terms')
end

When /^I click sign up$/ do
  click_button('submit')
end

Then /^my details should be queued for further processing$/ do

  user = {
    :level                 => @level,
    :organisation_name     => @organisation_name,
    :contact_name          => @contact_name,
    :email                 => @email,
    :phone                 => @phone,
    :address_line1         => @address_line1,
    :address_line2         => @address_line2,
    :address_city          => @address_city,
    :address_region        => @address_region,
    :address_country       => @address_country,
    :address_postcode      => @address_postcode,
    :tax_number            => @tax_number,
    :purchase_order_number => @purchase_order_number,
    :agreed_to_terms       => @agreed_to_terms
  }

  Resque.should_receive(:enqueue).with(SignupProcessor, user).once
end

Then /^I should see an error relating to (.*)$/ do |text|
  #puts @member.errors.keys
  #@member.errors.keys.should include(field.to_sym)
  
  page.should have_content "#{text} can't be blank"
end

Then /^I should get an error telling me to accept the terms$/ do
  page.should have_content "Agreed to terms must be accepted"
end

Then /^my details should not be queued$/ do
  Resque.should_not_receive(:enqueue)
end
