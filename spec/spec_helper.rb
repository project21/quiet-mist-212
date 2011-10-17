# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'database_cleaner'
DatabaseCleaner.clean_with :truncation

require 'blueprints'

DatabaseCleaner[:active_record].strategy = :transaction

RSpec.configure do |c|
  c.include(Capybara, :type => :integration) 
  c.include Factory::Syntax::Methods
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  c.mock_with :rr
  #config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  c.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  c.use_transactional_fixtures = true

  c.before(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end 
  c.before(:each) do
    DatabaseCleaner[:active_record].start
  end 
  c.after(:each) do
    DatabaseCleaner[:active_record].clean
  end 

end
