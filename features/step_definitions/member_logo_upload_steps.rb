# membership id
Given /^that my organisation has a membership ID "(.*?)"$/ do |membership_id|
  @membership_id = membership_id
end

# source locations for the logo
Given /^my organisations logo is in the file "(.*?)"$/ do |logo_source_path|
  @logo_source_path = logo_source_path
end

# upload
When /^I upload my organisations logo from a local file$/ do
  pending
  # do carrierwave stuff here
  #fill_in('member_organization_attributes_description', :with => @logo_source_path)
end

# storage
Then /^it should be stored in the container named "(.*?)" with CDN URI "(.*?)"$/ do |container, cdn_uri|
  pending
  #@container = container
  #@cdn_uri = cdn_uri
end

# destinations
Then /^the fullsize logo should be available at the URL "(.*?)"$/ do |logo_url_fullsize|
  pending
  #@logo_url_fullsize = logo_url_fullsize
end

Then /^the logo thumbnail should be available at the URL "(.*?)"$/ do |logo_url_thumbnail|
  pending
  #@logo_url_thumbnail = logo_url_thumbnail
end
