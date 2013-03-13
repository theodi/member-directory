
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider           => 'Rackspace',
    :rackspace_username => ENV['RACKSPACE_USERNAME'],
    :rackspace_api_key  => ENV['RACKSPACE_API_KEY']
  }
  #config.fog_directory = 'name_of_directory'
  config.fog_directory = 'theodi-members-logos'
  # set cdn hostname here
  #config.asset_host = "http://c000000.cdn.rackspacecloud.com"
end