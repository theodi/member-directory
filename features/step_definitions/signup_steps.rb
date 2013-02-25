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
  # Store for later
  @contact_name          = 'Ian McIain'
  @email                 = 'iain@foobar.com'
  @organisation_name     = 'FooBar Inc'
  @phone                 = '0121 123 446'
  @address_line1         = '123 Fake Street'
  @address_line2         = 'Fake place'
  @address_city          = 'Faketown'
  @address_region        = 'Fakeshire'
  @address_country       = 'UK'
  @address_postcode      = 'FAKE 123'
  @tax_number            = '213244343'
  @purchase_order_number = 'PO-43243242342'  
  # Fill in form
  fill_in('member_level',                 :with => @level)
  fill_in('member_contact_name',          :with => @contact_name)
  fill_in('member_email',                 :with => @email)
  fill_in('member_organisation_name',     :with => @organisation_name)
  fill_in('member_phone',                 :with => @phone)
  fill_in('member_address_line1',         :with => @address_line1)
  fill_in('member_address_line2',         :with => @address_line2)
  fill_in('member_address_city',          :with => @address_city)
  fill_in('member_address_region',        :with => @address_region)
  fill_in('member_address_country',       :with => @address_country)
  fill_in('member_address_postcode',      :with => @address_postcode)
  fill_in('member_tax_number',            :with => @tax_number)
  fill_in('member_purchase_order_number', :with => @purchase_order_number)
  fill_in('member_password',              :with => 'p4ssw0rd')
  fill_in('member_password_confirmation', :with => 'p4ssw0rd')

  check('member_agreed_to_terms')
  
end

When /^I leave (\w*) blank$/ do |field|
  fill_in("member_#{field}", :with => nil)
end

When /^I don't agree to the terms$/ do
  uncheck('member_agreed_to_terms')
end

When /^my passwords don't match$/ do
  fill_in('member_password_confirmation', :with => 'password')
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
    :purchase_order_number => @purchase_order_number
  }

  Resque.should_receive(:enqueue).with(SignupProcessor, user).once
end

And /^I should have a membership number generated$/ do
  Member.find_by_email('iain@foobar.com').membership_number.should_not be_nil
end

And /^I should not have a membership number generated$/ do
  # Guh?
end

Then /^I should see an error relating to (.*)$/ do |text|
  #puts @member.errors.keys
  #@member.errors.keys.should include(field.to_sym)
  
  page.should have_content "#{text} can't be blank"
end

Then /^I should get an error telling me to accept the terms$/ do
  page.should have_content "Agreed to terms must be accepted"
end

When /^I should get an error telling my passwords don't match$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^my details should not be queued$/ do
  Resque.should_not_receive(:enqueue)
end
