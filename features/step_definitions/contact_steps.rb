When /^I visit the contact page$/ do
  visit("/contact_requests/new?level=#{@product_name}")
  page.should have_content 'Contact us'
  @field_prefix = 'contact_request'
end

When /^I enter my request details$/ do
  # My details
  @person_name = 'Brian McBrian'
  @person_affiliation = 'BrianCorp Ltd.'
  @person_email = 'brian@example.com'
  @person_telephone = '+44 1233 432454'
  @person_job_title = 'CEO'
  @comment_text = 'I want to be a member SO BAD!'
  # Fill in form
  fill_in('contact_request_person_name',         :with => @person_name)
  fill_in('contact_request_person_affiliation',  :with => @person_affiliation)
  fill_in('contact_request_person_email',        :with => @person_email)
  fill_in('contact_request_person_telephone',    :with => @person_telephone)
  fill_in('contact_request_person_job_title',    :with => @person_job_title)
  fill_in('contact_request_comment_text',        :with => @comment_text)
end

Then /^my request should be queued for further processing$/ do
  person = {
    'name'        => @person_name,
    'affiliation' => @person_affiliation,
    'email'       => @person_email,
    'telephone'   => @person_telephone,
    'job_title'   => @person_job_title
  }
  product = {
    'name' => @product_name
  }
  comment = {
    'text' => @comment_text
  }
  Resque.should_receive(:enqueue).with(PartnerEnquiryProcessor, person, product, comment)
end

When /^I click contact me$/ do
  click_button('Contact me')
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content(text)
end