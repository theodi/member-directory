source 'https://rubygems.org'

#ruby=ruby-1.9.3
#ruby-gemset=member-directory

gem 'rails', '~> 3.2.12'

gem 'sqlite3'
gem 'devise', '~> 2.2.4'
gem 'dotenv'
gem 'fog', '~> 1.12.1'
gem 'carrierwave'
gem 'mini_magick'
gem 'rabl'
gem 'alternate_rails', :git => 'https://github.com/theodi/alternate-rails.git'
gem 'rails_admin'

# Lock ruby-openid to a particular version to resolve login problems.
# Reasons described in https://github.com/sishen/omniauth-google-apps/issues/6.
# We need ruby-openid to fix https://github.com/openid/ruby-openid/issues/51 before we can go back on the mainline.
gem "ruby-openid", :git => "git://github.com/kendagriff/ruby-openid.git", :ref => "79beaa419d4754e787757f2545331509419e222e"
gem 'omniauth-google-apps'

# We use this version as the original gem only allows Rails up to 3.0.11
gem 'data_migrate', :git => 'https://github.com/doublewide/data-migrate.git'

gem 'validate_url'

# Manually specify some dependencies so we use our own version
gem 'xeroizer', :git => 'https://github.com/theodi/xeroizer.git'
gem 'capsulecrm', :git => 'https://github.com/theodi/capsulecrm.git'

gem 'open-orgn-services', :git =>  'https://github.com/theodi/open-orgn-services.git'

gem 'rack-google-analytics'

gem 'airbrake'
gem 'rdiscount'
gem 'stripe'
gem 'country_select', github: 'stefanpenner/country_select'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

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


group :development, :test do
  gem 'cucumber-rails', :require => false
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
  gem 'simplecov-rcov'
  gem 'travis'
  gem 'rspec-html-matchers'
  gem 'csvlint'
end

group :test do
  gem 'poltergeist'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'foreman', '< 0.65.0'
  gem 'thin'
  gem 'mysql2'
end
