
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider           => 'Rackspace',
    :rackspace_username => ENV['RACKSPACE_USERNAME'],
    :rackspace_api_key  => ENV['RACKSPACE_API_KEY'],
    :rackspace_auth_url => ENV['RACKSPACE_API_ENDPOINT']
  }
  config.fog_directory = 'theodi-members-logos'
  config.asset_host = "http://3c15e477272a919c85ab-3fbe4c8744736fb7318f7d4ea2dff54a.r10.cf3.rackcdn.com"
end