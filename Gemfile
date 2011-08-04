source 'http://rubygems.org'

gem 'yajl-ruby'

gem 'rails', '3.1.0.rc4'
gem 'active_reload'

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
  gem 'therubyracer'
end

gem 'devise', '1.4.2'
gem 'omniauth'
gem "foreigner"

gem 'simple_form'
gem 'enumerated_attribute'

gem 'google-book', :require => 'google/book'
gem 'api_smith'


group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'unicorn', :platform => :ruby
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'rr'
end
