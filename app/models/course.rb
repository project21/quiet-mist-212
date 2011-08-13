class Course < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :school_id

  has_many :user_courses
  belongs_to :school
end
