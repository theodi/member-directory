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
  expect(row["university_name"]).to eql "University of Life"
  expect(row["qualification"]).to eql "BSc"
  expect(row["course_name"]).to eql "Quantum Morphogenetics"
  expect(row["course_start_month"]).to eql "09"
  expect(row["course_start_year"]).to eql "2013"
  expect(row["course_end_month"]).to eql "06"
  expect(row["course_end_year"]).to eql "2016"
end