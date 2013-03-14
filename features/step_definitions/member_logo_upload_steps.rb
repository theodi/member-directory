# membership id
Given /^that my organisation has a membership ID "(.*?)"$/ do |membership_id|
  @membership_id = membership_id
end

# source locations for the logo
Given /^my organisations logo is in the file "(.*?)"$/ do |logo_source_path|
  @logo_source_path = logo_source_path
end

Given /^my organisations logo is online at the URL "(.*?)"$/ do |logo_source_url|
  @logo_source_url = logo_source_url
end

# upload
When /^I upload my organisations logo from a local file$/ do
  # do carrierwave stuff here
  uploader = ImageObjectUploader.new
  uploader.store!(@logo_source_path)
end

When /^I upload my organisations logo from a URL$/ do
  pending # do carrierwave stuff here
end

# storage
Then /^it should be stored in the container named "(.*?)" with CDN URI "(.*?)"$/ do |container, cdn_uri|
  @container = container
  @cdn_uri = cdn_uri
end

# destinations
Then /^the fullsize logo should be available at the URL "(.*?)"$/ do |logo_url_fullsize|
  @logo_url_fullsize = logo_url_fullsize
end

Then /^the logo thumbnail should be available at the URL "(.*?)"$/ do |logo_url_thumbnail|
  @logo_url_thumbnail = logo_url_thumbnail
end
