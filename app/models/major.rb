class Major < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  # this is denormed into the User model
  attr_readonly :name
end
