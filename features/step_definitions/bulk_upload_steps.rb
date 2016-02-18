Given(/^I visit the student bulk upload page$/) do
  visit "/uploads/new"
end

When(/^I click "(.*?)"$/) do |arg1|
  click_on arg1
end

Then(/^I should receive a CSV file called "(.*?)"$/) do |arg1|
  
end

Then(/^that CSV file should contain columns for all student signup fields$/) do
  csv = CSV.parse(page.body, headers: true)
  expect(csv.headers).to eql %w{
    name
    email
    dob_day
    dob_month
    dob_year
    address_street
    address_locality
    address_town
    address_country
    address_postcode
    university_name
    qualification
    course_name
    course_start_month
    course_start_year
    course_end_month
    course_end_year
    coupon_code
  }
end

Then(/^that CSV should have an example line\.$/) do
  csv = CSV.parse(page.body, headers: true)
  row = csv.first
  expect(row["name"]).to eql "Bob Fish"
  expect(row["email"]).to eql "bob@example.edu"
  expect(row["dob_day"]).to eql "01"
  expect(row["dob_month"]).to eql "02"
  expect(row["dob_year"]).to eql "1990"
  expect(row["address_street"]).to eql "29 Acacia Road"
  expect(row["address_locality"]).to eql ""
  expect(row["address_town"]).to eql "London"
  expect(row["address_country"]).to eql "GB"
  expect(row["address_postcode"]).to eql "SW1A 1AA"
  expect(row["university_name"]).to eql "Aberdeen"
  expect(row["qualification"]).to eql "BSc - Bachelor of Science"
  expect(row["course_name"]).to eql "Quantum Morphogenetics"
  expect(row["course_start_month"]).to eql "09"
  expect(row["course_start_year"]).to eql "2013"
  expect(row["course_end_month"]).to eql "06"
  expect(row["course_end_year"]).to eql "2016"
  expect(row["coupon_code"]).to eql "SUPERFREE"
end

When(/^that file contains a set of student details$/) do
  @contact_name = "Bob Fish"
  @email = "bob@example.edu"
  @dob = Date.new(1990,2,1)
  @street_address = "29 Acacia Road"
  @address_locality = ""
  @address_region = "London"
  @address_country = "United Kingdom"
  @postal_code = "SW1A 1AA"
  @university_email = "bob@example.edu"
  @university_address_country = "GB"
  @university_country = "GB"
  @university_name = "Other (please specify)"
  @university_name_other = "University of Life"
  @university_course_name = "Quantum Morphogenetics"
  @university_qualification = "BSc - Bachelor of Science"
  @university_course_start_date = Date.new(2013,9)
  @university_course_end_date = Date.new(2016,6)
  @origin = "odihq"
  @newsletter = true
  @share_with_third_parties = false
  @payment_method = "credit_card"
  @product_name = "student"
  @coupon = double(code: "SUPERFREE")
end

When(/^I select the file "(.*?)" for upload$/) do |arg1|
  attach_file "file", File.join(Rails.root, "fixtures", arg1)
end

Then(/^I should see the results of my upload$/) do
  expect(page.body).to include("Loaded 1 new member from CSV.")
  expect(page.body).to include("Bob Fish")
  expect(page.body).to include("bob@example.edu")
end

Then(/^their details should be queued for adding to Chargify$/) do
  expect(Resque).to receive(:enqueue).with(NoninteractiveAddToChargify, Member.count+1)
end

Then(/^after the chargify job has run$/) do
  NoninteractiveAddToChargify.perform(@member.id)
  @member = Member.find(@member.id)
end

