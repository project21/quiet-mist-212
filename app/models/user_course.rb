class UserCourse < ActiveRecord::Base
  col :user_id,   as: :integer, null: false
  col :course_id, as: :integer, null: false
  col :active,    as: :boolean, null: false

  belongs_to :user
  belongs_to :course
end
