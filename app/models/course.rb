class Course < ActiveRecord::Base
  col :name, as: :string
  col :created_at, as: :timestamp
  col :updated_at, as: :timestamp
  col :school_id, as: :integer

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :school_id

  has_many :user_courses
  has_many :class_groups
  belongs_to :school
end
