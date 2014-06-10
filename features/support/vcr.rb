require 'vcr'
require 'webmock/cucumber'

VCR.configure do |c|
  # Automatically filter all secure details that are stored in the environment
  ignore_env = %w{SHLVL RUNLEVEL GUARD_NOTIFY DRB COLUMNS USER LOGNAME LINES ITERM_PROFILE TODO AUTOFEATURE}
  (ENV.keys-ignore_env).select{|x| x =~ /\A[A-Z_]*\Z/}.each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
  c.default_cassette_options = { :record => :once }
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
