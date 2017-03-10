Given /^the student coupon code SUPERFREE is in Chargify$/ do
  @chargify_product_url = "http://test.host/product/individual-supporter-student"
  @chargify_product_price = 800
  @coupon = double(:code => "SUPERFREE", :percentage => 100)
  Member.register_chargify_product_price("individual-supporter-student", @chargify_product_price*100)
  Member.register_chargify_coupon_code(@coupon)
end

Given /^there is already an organization with the name '(.*?)'$/ do |org_name|
  FactoryGirl.create :member, :organization_name => org_name
end

Given(/^a sponsor account already exists$/) do
  @password = 'password'
  @email = Faker::Internet.email
  @member = FactoryGirl.build(:member,
    :product_name          => "supporter",
    :organization_name     => Faker::Company.name,
    :password              => @password,
    :password_confirmation => @password,
    :email                 => @email
  )

  @member.save!
  @member.current!
end

Given(/^I have a (sponsor|partner) account$/) do |level|
  @password = 'password'
  @email = Faker::Internet.email
  @member = FactoryGirl.build :member, :product_name => level, :organization_name => Faker::Company.name,
                         :password => @password, :password_confirmation => @password, :email => @email
  @member.remote!
  @member.save!
  @member.current!
  @membership_number = @member.membership_number
  steps %{
    When I visit the sign in page
    And I enter my membership number and password
    And the password is correct
    And I click sign in
  }
end

Given(/^I visit my account page$/) do
  visit member_path(@member)
end

Given(/^I visit their account page$/) do
  visit member_path(@member)
end

When /^I enter my name and contact details$/ do
  @contact_name = 'Ian McIain'
  @email ||= 'iain@foobar.com'
  @telephone = '0121 123 446'
  @share_with_third_parties = false
  @twitter = nil
  # @coupon_code ||= @coupon.code

  fill_in('member_contact_name', :with => @contact_name)
  fill_in('member_email', :with => @email)
  fill_in('member_telephone', :with => @telephone)

  fill_in('member_password', :with => @password || 'p4ssw0rd')
  fill_in('member_password_confirmation', :with => @password || 'p4ssw0rd')
end

When /^I enter my address details$/ do
  @street_address = '123 Fake Street'
  @address_region = 'Faketown'
  @address_country = 'United Kingdom'
  @postal_code = 'FAKE 123'

  fill_in('member_street_address', :with => @street_address)
  fill_in('member_address_region', :with => @address_region)
  select(@address_country, from: :member_address_country, match: :first)
  fill_in('member_postal_code', :with => @postal_code)
end

Then /^(their|my) details should be queued for further processing$/ do |ignore|
  organization = {
    'name' => @organization_name,
    'vat_id' => @organization_vat_id,
    'company_number' => @organization_company_number,
    'size' => @organization_size,
    'type' => @organization_type,
    'sector' => @organization_sector,
    'origin' => @origin,
    'newsletter' => true,
    'share_with_third_parties' => @share_with_third_parties
  }

  contact_person = {
    'name'                           => @contact_name,
    'email'                          => @email,
    'telephone'                      => @telephone,
    'twitter'                        => @twitter,
    'dob'                            => @dob,
    'country'                        => @address_country,
    'university_email'               => @university_email,
    'university_address_country'     => @university_address_country,
    'university_country'             => @university_country,
    'university_name'                => @university_name,
    'university_name_other'          => @university_name_other,
    'university_course_name'         => @university_course_name,
    'university_qualification'       => @university_qualification,
    'university_qualification_other' => @university_qualification_other,
    'university_course_start_date'   => @university_course_start_date,
    'university_course_end_date'     => @university_course_end_date
  }

  billing = {
    'name' => @contact_name,
    'email' => @email,
    'telephone' => @telephone,
    'address' => {
      'street_address' => @street_address,
      'address_locality' => @address_locality,
      'address_region' => @address_region,
      'address_country' => @address_country,
      'postal_code' => @postal_code
    },
    'coupon' => @coupon ? @coupon.code : nil
  }

  purchase = {
    'discount' => @discount
  }

  expect(Resque).to receive(:enqueue) do |*args|
    expect(args[0]).to eql SignupProcessor
    expect(args[1]).to eql organization
    expect(args[2]).to eql contact_person
    expect(args[3]).to eql billing
    expect(args[4]['payment_method']).to eql @payment_method
    expect(args[4]['payment_ref']).to eql @payment_ref
    expect(args[4]['offer_category']).to eql @product_name
    expect(args[4]['membership_id']).not_to eql nil
    expect(args[4]['amount_paid']).to eq(@amount)
  end
end

Then /^I should see an error relating to (.*)$/ do |text|
  expect(page.find(:css, "div.alert-error")).to have_content(text)
end

Then /^I should not see an error$/ do
  expect(page).to_not have_css("div.alert-error")
end

Then /^a welcome email should be sent to me$/ do
  steps %Q{
    Then a welcome email should be sent to "#{@email}"
  }
end

Then(/^a welcome email should be sent to "(.*?)"$/) do |email|
  steps %Q{
    Then "#{email}" should receive an email
    When they open the email
    And they should see the email delivered from "members@theodi.org"
    And they should see "mailto:members@theodi.org" in the email body
  }
  expect(current_email).to bcc_to(%w(members@theodi.org))
end

Given(/^I have signed up, but haven't paid$/) do
  steps %{
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    And I click sign up
  }
end

Given(/^I try to sign up again$/) do
  steps %{
    Given that I want to sign up as a supporter
    And product information has been setup for "corporate-supporter_annual"
    When I visit the signup page
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    And I click sign up
  }
end

Then(/^I should be redirected to the login page$/) do
  expect(current_path).to eq(new_member_session_path)
end

Then(/^I should see an error telling me I need to login$/) do
  expect(page.body).to include("You have already started the signup process, to continue to payment, please login.")
end

Then(/^I log in$/) do
  fill_in('member_password', :with => @original_password)
  click_button('submit')
end

Then(/^an? (.*?) membership should be created for "(.*?)"$/) do |product_name, email|
  @member = Member.where(email: email).first
  expect(@member).to be_present
  expect(@member.product_name).to eql product_name
  @email = email
  steps %Q{
    Then they should have a membership number generated
    Then they should be marked as active
  }
end

Then(/^that member should be set up in Chargify$/) do
  expect(@member.chargify_subscription_id).to be_present
end