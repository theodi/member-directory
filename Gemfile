source 'https://rubygems.org'

gem 'rails', '~> 3.2'

gem 'devise', '~> 2.2'
gem 'dotenv'
gem 'fog' #, '~> 1.12.1'
gem 'carrierwave'
gem 'mini_magick'
gem 'rabl'
gem 'alternate_rails', git: 'https://github.com/theodi/alternate-rails.git', branch: "83a5b8b73655283b2d9729eeae848488881eecc4"
gem 'rails_admin', "~> 0.4"
gem 'chargify_api_ares'
gem 'omniauth-google-oauth2'

gem 'validate_url'

# These should be grabbed from git, not rubygems, as we have our own fixes
gem 'capsulecrm', github: 'xmacinka/capsulecrm'
gem 'eventbrite-client', github: 'theodi/eventbrite-client.rb', branch: 'update-dependencies'

gem 'open-orgn-services', github: 'theodi/open-orgn-services'

gem 'rack-google-analytics'

gem 'airbrake'
gem 'rdiscount'
gem 'stripe'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'ransack'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'zeroclipboard-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem 'mysql2'


group :development, :test do
  gem 'sqlite3'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'guard-cucumber'
  gem 'rb-fsevent', '~> 0.9'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'timecop'
  gem 'email_spec', require: false
  gem 'mailcatcher'
  gem 'travis'
  gem 'rspec-html-matchers', require: false, github: 'theodi/rspec-html-matchers'
  gem 'csvlint'
  gem 'coveralls'
end

group :test do
  gem 'poltergeist'
  gem 'webmock', require: false
end

group :production do
  gem 'foreman', '< 0.65.0'
  gem 'thin'
end
