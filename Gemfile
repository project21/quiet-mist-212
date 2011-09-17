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

platform :mswin, :mingw do
  gem 'sqlite3'
end

platform :ruby do
  gem 'pg'
  gem 'therubyracer'
  gem 'unicorn'
end

gem 'devise'
#gem 'omniauth' #, :git => 'https://github.com/intridea/omniauth.git', :branch => '1.0-beta'
gem "foreigner"

gem 'squeel'
gem 'simple_form'
gem 'enumerated_attribute'

gem 'google-book', :require => 'google/book'
gem 'api_smith'

group :development, :test do
  gem 'awesome_print', :require => 'awesome_print'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'pry', :require => 'pry'
  gem 'unicorn', :platform => :ruby
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  #gem 'factory_girl_rails'
  gem 'factory_girl', '~>2.0'
  gem 'rr'
end
