source 'http://rubygems.org'

gem 'yajl-ruby'

gem 'rails', '3.1'
#gem 'active_reload'

# asset pipeline helpers
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'

gem 'fog'
gem 'carrierwave'

gem 'jquery-rails'
gem 'rake'

platform :mswin, :mingw do
  gem 'sqlite3'
end

platform :ruby do
  gem 'pg'
  gem 'therubyracer'
end

gem 'devise'
gem 'omniauth', '0.3.0.rc3'
gem "foreigner"

gem 'squeel'
gem 'simple_form'
gem 'enumerated_attribute'

gem 'google-book', :require => 'google/book'
gem 'api_smith'


group :development, :test do
  gem 'ap', :require => 'ap'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'unicorn', :platform => :ruby
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  # TODO: switch to latest factory girl
  gem 'machinist', '>= 2.0.0.beta2'
  #gem 'factory_girl_rails'
  gem 'rr'
end
