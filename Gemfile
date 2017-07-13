source 'https://rubygems.org'
ruby "2.4.1"

gem 'rails', '~> 4.2'
gem 'devise', '~> 3.5'
gem 'psych' # explicit dependency required for Heroku
gem 'dotenv'
gem 'fog'
gem 'carrierwave'
gem 'mini_magick'
gem 'rabl'
gem 'alternate_rails', git: 'https://github.com/theodi/alternate-rails.git', branch: "v4.2.0"
gem 'rails_admin'
gem 'omniauth-google-oauth2'

gem 'validate_url'

gem 'rack-google-analytics'

gem 'rdiscount'
gem 'country_select'
gem 'ransack'

gem 'sass-rails'
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.0.3'

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

group :development do
  gem 'web-console', '~> 3.3' 
end

group :development, :test do
  gem 'sqlite3'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'guard-cucumber'
  gem 'rb-fsevent', '~> 0.10'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'faker', '1.6.6' #lock for now due to i18n bugs with ruby 2.2
  gem 'timecop'
  gem 'email_spec', require: false
  gem 'mailcatcher'
  gem 'travis'
  gem 'rspec-html-matchers'
  gem 'csvlint'
  gem 'coveralls'
  gem 'byebug'
  gem 'test-unit'
end

group :test do
  gem 'poltergeist'
  gem 'webmock', require: false
end

group :production do
  gem 'airbrake'
  gem 'rails_12factor'
  gem 'foreman', '< 0.84.0'
  gem 'thin'
end
