Given(/^I want to sign up as an student member$/) do
  @product_name = 'student'
  @payment_method = 'credit_card'
  @payment_ref = /cus_[0-9A-Za-z]{14}/
end

Then(/^I should not be asked for organization details$/) do
  steps %{
    Then I should not see the "Organisation Name" field
    And I should not see the "Organisation size" field
    And I should not see the "Organisation type" field
    And I should not see the "Industry sector" field
    And I should not see the "Company Number" field
  }
end

Then(/^I should not be asked for financial information$/) do
  steps %{
    And I should not see the "VAT Number (if not UK)" field
    And I should not see the "Purchase Order Number" field
  }
end

When(/^I enter my university details$/) do

  # University email address
  fill_in('member_university_email', :with => "test@example.com")

  # University details
  select("York", from: :member_university_name, match: :first)
  fill_in('member_university_street_address', :with => "1 Some Street")
  fill_in('member_university_address_locality', :with => "Some town")
  fill_in('member_university_address_region', :with => "Some region")
  select("United Kingdom", from: :member_university_address_country, match: :first)
  fill_in('member_university_postal_code', :with => "WC1E 6BT")

  # University course and qualification
  fill_in(:member_university_course_name, :with => "Course name")
  select("BSc - Bachelor of Science", from: :member_university_qualification, match: :first)
  fill_in("member_university_course_start_date", :with => "04/10/2015")
  fill_in("member_university_course_end_date", :with => "04/10/2015")

  # Date of birth
  fill_in("member_dob", :with => "01/01/1989")
end

When(/^my student details should be saved$/) do
  expect(@member).to_not be_nil
  expect(@member.university_email).to eq("test@example.com")
  expect(@member.university_name).to eq("York")
  expect(@member.university_street_address).to eq("1 Some Street")
  expect(@member.university_address_locality).to eq("Some town")
  expect(@member.university_address_region).to eq("Some region")
  expect(@member.university_address_country).to eq("GB")
  expect(@member.university_postal_code).to eq("WC1E 6BT")
  expect(@member.university_course_name).to eq("Course name")
  expect(@member.university_qualification).to eq("BSc - Bachelor of Science")
  expect(@member.university_course_start_date.to_s).to eq("2015-10-04")
  expect(@member.university_course_end_date.to_s).to eq("2015-10-04")
  expect(@member.dob.to_s).to eq("1989-01-01")
end

