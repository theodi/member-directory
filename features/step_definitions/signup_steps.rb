Given /^that I want to sign up as a (\w*)$/ do |level|
  @level = level # Required
end

Given /^that I want to sign up$/ do
  @level = 'supporter'
end

When /^I visit the signup page$/ do
  visit("/members/sign_up?level=#{@level}")
  page.should have_content 'Sign up'  
end

When /^I enter my details$/ do
  # Store for later
  @contact_name          = 'Ian McIain'
  @email                 = 'iain@foobar.com'
  @organisation_name     = 'FooBar Inc'
  @telephone                 = '0121 123 446'
  @street_address         = '123 Fake Street'
  @address_city          = 'Faketown'
  @address_region        = 'Fakeshire'
  @address_country       = 'UK'
  @address_postcode      = 'FAKE 123'
  @tax_number            = '213244343'
  @purchase_order_number = 'PO-43243242342'  
  # Fill in form
  fill_in('member_contact_name',          :with => @contact_name)
  fill_in('member_email',                 :with => @email)
  fill_in('member_organisation_name',     :with => @organisation_name)
  fill_in('member_telephone',                 :with => @telephone)
  fill_in('member_street_address',         :with => @street_address)
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
      
  organization    = {'name' => @organisation_name, 'vat_id' => @tax_number}
  contact_person  = {'name' => @contact_name, 'email' => @email, 'telephone' => @telephone}
  billing         = {
                      'name' => @contact_name,
                      'email' => @email,
                      'telephone' => @telephone,
                      'address' => {
                        'street_address' => @street_address,
                        'address_locality' => @address_city,
                        'address_region' => @address_region,
                        'address_country' => @address_country,
                        'postal_code' => @address_postcode
                      }
                    }
                    
  Resque.should_receive(:enqueue).with do |*args|
    args[0].should == SignupProcessor
    args[1].should == organization
    args[2].should == contact_person
    args[3].should == billing
    args[4]['offer_category'].should == @level
    args[4]['membership_id'].should_not be_nil
    args[4]['purchase_order_reference'].should == @purchase_order_number
  end 
end

And /^I should have a membership number generated$/ do
  member = Member.find_by_email(@email)
  member.membership_number.should_not be_nil
  member.membership_number.should match(/[A-Z]{2}[0-9]{4}[A-Z]{2}/)
end

Then /^I should see an error relating to (.*)$/ do |text|
  page.should have_content "#{text} can't be blank"
end

Then /^I should see that the level is invalid$/ do
  page.should have_content "Level is not included in the list"
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
