Chargify.configure do |c|
  c.api_key = ENV['CHARGIFY_API_KEY']
  c.subdomain = ENV['CHARGIFY_SUBDOMAIN']
end
