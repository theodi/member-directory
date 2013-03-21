Given /^I am not currently a member$/ do
end

Given /^I am already signed up$/ do
  @membership = FactoryGirl.create :member
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
  @contact_name      = Faker::Name.name
  @contact_phone     = Faker::PhoneNumber.phone_number
  @contact_email     = Faker::Internet.email
  @twitter           = Faker::Internet.url
  @linkedin          = Faker::Internet.url
  @facebook          = Faker::Internet.url
end

When /^the sync task runs$/ do
  membership = {
    'email'         => @email,
    'product_name'  => @product_name,
    'id'            => @membership_id,
  }.compact
  directory_entry = {
    'active'        => @active,
    'name'          => @organization_name,
    'description'   => @description,
    'url'           => @url,
    'contact'       => @contact_name,
    'phone'         => @contact_phone,
    'email'         => @contact_email,
    'twitter'       => @twitter,
    'linkedin'      => @linkedin,
    'facebook'      => @facebook,
  }.compact
  CapsuleObserver.update(membership, directory_entry)
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
  @membership.cached_active.should                     == (@active == "true")
  @membership.organization.name.should                 == @organization_name
  @membership.organization.description.should          == @description
  @membership.organization.url.should                  == @url
  @membership.product_name.should                      == @product_name
  @membership.organization.cached_contact_name.should  == @contact_name
  @membership.organization.cached_contact_phone.should == @contact_phone
  @membership.organization.cached_contact_email.should == @contact_email
  @membership.organization.cached_twitter.should       == @twitter
  @membership.organization.cached_linkedin.should      == @linkedin
  @membership.organization.cached_facebook.should      == @facebook
end

Then /^nothing should be placed on the queue$/ do
  Resque.should_not_receive(:enqueue)
end

Then /^nothing should be placed on the signup queue$/ do
  Resque.should_not_receive(:enqueue).with do |*args| 
    args[0] == SignupProcessor
  end
end

Then /^my membership number should be stored in CapsuleCRM$/ do
  Resque.should_receive(:enqueue).with do |*args|
    args[0].should == SaveMembershipIdInCapsule
    args[1].should == @organization_name
    args[2].should == Member.where(:email => @email).first.membership_number
  end.once
end