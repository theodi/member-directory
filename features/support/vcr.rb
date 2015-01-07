require 'vcr'
require 'webmock/cucumber'

VCR.configure do |c|
  # Automatically filter all secure details that are stored in the environment
  (ENV.keys - $ignore_env).select { |x| x =~ /\A[A-Z_]*\Z/ }.each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
  c.default_cassette_options = { record: :once }
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.ignore_hosts 'lon.auth.api.rackspacecloud.com'
  c.ignore_request do |request|
    URI(request.uri).host =~ %r{.*\.clouddrive\.com.*}
  end
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
