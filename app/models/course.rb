class Course < ActiveRecord::Base
  validates_presence_of :subject
  validates_uniqueness_of :subject, :scope => :school_id

  has_many :user_courses
  belongs_to :school
end
