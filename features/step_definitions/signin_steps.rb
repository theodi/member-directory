Given /^that I have a membership number and password$/ do
  # We don't care about queueing here - we will have a separate expectation if we do, anyway.
  Resque.should_receive(:enqueue).once
  # Create a new member
  member = Member.create(
    :product_name                 => 'supporter',
    :organisation_name     => 'FooBar Inc',
    :contact_name          => 'Ian McIain',
    :email                 => 'iain@foobar.com',
    :telephone                 => '0121 123 446',
    :street_address         => '123 Fake Street',
    :address_locality          => 'Faketown',
    :address_region        => 'Fakeshire',
    :address_country       => 'UK',
    :postal_code      => 'FAKE 123',
    :organisation_vat_id            => '213244343',
    :purchase_order_number => 'PO-43243242342',
    :password              => 'p4ssw0rd',
    :password_confirmation => 'p4ssw0rd',
    :agreed_to_terms       => '1'
  )
  
  member.confirm!
  
  @membership_number = member.membership_number
  @password = 'p4ssw0rd'
end

When /^I visit the sign in page$/ do
  visit('/members/sign_in')
  page.should have_content 'Sign in'  
end

When /^I enter my membership number and password$/ do
  fill_in('member_membership_number', :with => @membership_number)
end

And /^the password is correct$/ do
  fill_in('member_password', :with => @password)
end

When /^I click sign in$/ do
  click_button('submit')
end

Then /^I should have signed in successfully$/ do
  page.should have_content "Signed in successfully"
end

And /^the password is incorrect$/ do
  fill_in('member_password', :with => 'Thisisnttherightpassword')
end

And /^the membership number is incorrect$/ do
  fill_in('member_membership_number', :with => '42342342342342')
end

Then /^I should have recieve an error$/ do
  page.should have_content "Invalid email or password"
end
