Given /^I am not currently a member$/ do
end

Given /^I am already signed up$/ do
  @membership = FactoryGirl.create :member
  STDOUT.puts @membership.email
end

When /^I am set as a member in CapsuleCRM$/ do
  @active            = "true"
  @email             = Faker::Internet.email
  @product_name      = 'partner'
end

When /^my information is changed in CapsuleCRM$/ do
  @active            = "true"
  @email             = Faker::Internet.email
  @organization_name = Faker::Company.name
  @description       = Faker::Company.bs
  @url               = Faker::Internet.url
  @product_name      = 'sponsor'
  @membership_id     = @membership.membership_number
end

When /^the sync task runs$/ do
  syncdata = {
    'active'        => @active,
    'email'         => @email,
    'name'          => @organization_name,
    'description'   => @description,
    'url'           => @url,
    'product_name'  => @product_name,
    'membership_id' => @membership_id,
  }.compact
  CapsuleObserver.update(syncdata)
end

Then /^a membership should be created for me$/ do
  @membership = Member.where(:email => @email).first
  @membership.should be_present
  @membership_id = @membership.membership_number
  @membership_id.should be_present
end

Then(/^that membership should not be shown in the directory$/) do
  @active = false
  @membership.cached_active.should == @active
end

Then /^my details should be cached correctly$/ do
  @membership = Member.where(:membership_number => @membership_id).first
  @membership.cached_active.should            == (@active == "true")
  @membership.organization.name.should        == @organization_name
  @membership.organization.description.should == @description
  @membership.organization.url.should         == @url
  @membership.product_name.should             == @product_name

end

Then /^nothing should be placed on the queue$/ do
  Resque.should_not_receive(:enqueue)
end

Then /^my membership number should be stored in CapsuleCRM$/ do
  pending # express the regexp above with the code you wish you had
end