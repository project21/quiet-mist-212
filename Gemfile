source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'

# asset pipeline helpers
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

if RUBY_PLATFORM =~ /mingw/
gem 'sqlite3'
else
gem 'pg'
end

gem 'devise'
gem 'omniauth'
#gem "rake", "0.8.7"
gem "foreigner"
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
end

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
