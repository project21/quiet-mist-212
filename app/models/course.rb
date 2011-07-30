class Course < ActiveRecord::Base
  validates_presence_of :subject
  validates_uniqueness_of :subject, :scope => :school_id

  belongs_to :school
end
