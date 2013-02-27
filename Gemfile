source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'sqlite3'
gem 'devise'
gem 'dotenv'

# Manually specify the xeroizer dependency so we use our own version
gem 'xeroizer', :git => 'https://github.com/theodi/xeroizer.git'

gem 'open-orgn-services', :git =>  'https://github.com/theodi/open-orgn-services.git'


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
end

