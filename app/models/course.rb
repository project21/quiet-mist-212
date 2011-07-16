class Course < ActiveRecord::Base
  validates_presence_of :subject

  belongs_to :campus
end
