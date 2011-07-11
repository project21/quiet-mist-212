source 'http://rubygems.org'

gem 'yajl-ruby'

gem 'rails', '3.1.0.rc4'

# asset pipeline helpers
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'
gem 'rake', '0.8.7'

platform :mswin, :mingw do
  gem 'sqlite3'
end

platform :ruby do
  gem 'pg'
end

gem 'devise', '1.4.2'
gem 'omniauth'
gem "foreigner"

gem 'simple_form'
gem 'enumerated_attribute'

# Use unicorn as the web server
# gem 'unicorn'

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'rr'
end
