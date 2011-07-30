class School < ActiveRecord::Base
  has_many :users
  has_many :courses

  validates_presence_of :name
end
