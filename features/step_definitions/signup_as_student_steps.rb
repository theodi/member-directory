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
  @dob                                = Date.parse("01/01/1989")
  @dob_day                            = "01"
  @dob_month                          = "01"
  @dob_year                           = "1989"
  @university_country                 = "GB"
  @university_address_country         = "GB"
  @university_course_end_date_year    = "2016"
  @university_course_end_date_month   = "November"
  @university_course_end_date         = Date.parse("2016/11/01")
  @university_course_name             = "Course name"
  @university_course_start_date_year  = "2011"
  @university_course_start_date_month = "September"
  @university_course_start_date       = Date.parse("2011/09/01")
  @university_email                   = "test@example.com"
  @university_name                    = "York"
  @university_name_other              = ""
  @university_qualification           = "BSc - Bachelor of Science"
  @university_qualification_other     = ""

  # University email address
  fill_in('member_university_email', :with => @university_email)

  # University details
  select(@university_name, from: :member_university_name, match: :first)

  # University course and qualification
  fill_in(:member_university_course_name, :with => @university_course_name)
  select(@university_qualification, from: :member_university_qualification, match: :first)
  select(@university_course_start_date_year, from: :member_university_course_start_date_year)
  select(@university_course_start_date_month, from: :member_university_course_start_date_month)
  select(@university_course_end_date_year, from: :member_university_course_end_date_year)
  select(@university_course_end_date_month, from: :member_university_course_end_date_month)

  # Date of birth
  fill_in(:member_dob_year,  :with => @dob_year)
  fill_in(:member_dob_month, :with => @dob_month)
  fill_in(:member_dob_day,   :with => @dob_day)
end

When(/^my student details should be saved$/) do
  expect(@member).to_not be_nil
  expect(@member.university_email).to eq("test@example.com")
  expect(@member.university_name).to eq("York")
  expect(@member.university_address_country).to eq("GB")
  expect(@member.university_course_name).to eq("Course name")
  expect(@member.university_qualification).to eq("BSc - Bachelor of Science")
  expect(@member.university_course_start_date.to_s).to eq("2011-09-01")
  expect(@member.university_course_end_date.to_s).to eq("2016-11-01")
  expect(@member.dob.to_s).to eq("1989-01-01")
end

