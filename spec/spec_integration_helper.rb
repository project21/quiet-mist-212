require 'spec_helper'
require 'capybara-webkit'

Capybara.javascript_driver = :webkit
Capybara.default_driver = :webkit

RSpec.configure do |c|
  c.include Factory::Syntax::Methods
end


