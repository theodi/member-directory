Given /^I am not currently a member$/ do
end

Given /^I am already signed up$/ do
  @membership = FactoryGirl.create :member
  @old_description = @membership.organization.description
end

When /^I am set as a member in CapsuleCRM$/ do
  @active            = "true"
  @email             = Faker::Internet.email
  @product_name      = 'partner'
  @newsletter        = false
  @capsule_id        = 1234
end

When /^my information is changed in CapsuleCRM$/ do
  @capsule_id        = 1234
  @active            = "true"
  @email             = Faker::Internet.email
  @newsletter        = true
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
  @tagline           = Faker::Company.bs
end

When /^the sync task runs$/ do
  membership = {
    'email'         => @email,
    'product_name'  => @product_name,
    'id'            => @membership_id,
    'newsletter'    => @newsletter,
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
    'tagline'       => @tagline,
  }.compact
  CapsuleObserver.update(membership, directory_entry, @capsule_id)
end

Then /^a membership should be created for me$/ do
  @membership = Member.where(:email => @email).first
  @membership.should be_present
  @membership_id = @membership.membership_number
  @membership_id.should be_present
  @old_description = @membership.organization.description
end

Then(/^that membership should have a confirmed email address$/) do
  @membership.should be_confirmed
end

Then(/^that membership should not be shown in the directory$/) do
  @active = false
  @membership.cached_active.should == @active
end

Then /^my details should be cached correctly$/ do
  @membership = Member.where(:membership_number => @membership_id).first
  @membership.cached_active.should                     == (@active == "true")
  @membership.product_name.should                      == @product_name
  @membership.cached_newsletter.should                 == @newsletter
  @membership.organization.name.should                 == @organization_name
  @membership.organization.description.should          == @old_description # description should not change when synced
  @membership.organization.url.should                  == @url
  @membership.organization.cached_contact_name.should  == @contact_name
  @membership.organization.cached_contact_phone.should == @contact_phone
  @membership.organization.cached_contact_email.should == @contact_email
  @membership.organization.cached_twitter.should       == @twitter
  @membership.organization.cached_linkedin.should      == @linkedin
  @membership.organization.cached_facebook.should      == @facebook
  @membership.organization.cached_tagline.should       == @tagline
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