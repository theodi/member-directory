source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'sqlite3'
gem 'devise'
gem 'dotenv'
gem 'fog', '~> 1.3.1'
gem 'carrierwave'

# We use this version as the original gem only allows Rails up to 3.0.11
gem 'data_migrate', :git => 'https://github.com/doublewide/data-migrate.git'

gem 'validate_url'

# Manually specify some dependencies so we use our own version
gem 'xeroizer', :git => 'https://github.com/theodi/xeroizer.git'
gem 'capsulecrm', :git => 'https://github.com/theodi/capsulecrm.git'

gem 'open-orgn-services', :git =>  'https://github.com/theodi/open-orgn-services.git'

gem 'rack-google-analytics'

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
end

group :production do
  gem 'foreman'
  gem 'thin'
  gem 'mysql2'
end
