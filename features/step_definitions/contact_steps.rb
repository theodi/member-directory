When /^I visit the contact page$/ do
  visit('/contact_requests/new')
  page.should have_content 'Contact us'
end

When /^I enter my request details$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^my request should be queued for further processing$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I click contact me$/ do
  pending # express the regexp above with the code you wish you had
end