source 'http://rubygems.org'

gem 'yajl-ruby'

gem 'rails', '3.1'
#gem 'active_reload'

# asset pipeline helpers
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'

gem 'carrierwave'
gem 'fog'
gem 'rmagick'

gem 'jquery-rails'
gem 'remotipart'
gem 'rake'

gem 'mini_record'

platform :mswin, :mingw do
  gem 'sqlite3'
end

platform :ruby do
  gem 'pg'
  gem 'therubyracer'
  gem 'unicorn'
end

gem 'devise'
gem 'omniauth'
gem "foreigner"

gem 'squeel'
gem 'simple_form'
gem 'enumerated_attribute'

gem 'httparty', '0.7.8'
gem 'google-book', :require => 'google/book'
gem 'api_smith'

group :development, :test do
  gem 'awesome_print', :require => 'awesome_print'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'pry', :require => 'pry'
  gem 'unicorn', :platform => :ruby
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-bundler'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl', '~>2.0'
  gem 'rr'
  gem 'ghostbuster', '0.3.6'
    #path: '../ghostbuster'
    #git: 'https://github.com/joshbuddy/ghostbuster'
end
