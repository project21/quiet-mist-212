class AddUserCourses < ActiveRecord::Migration
  def up
    create_table :user_courses do |t|
      t.integer :user_id
      t.integer :course_id
    end
  end

  def down
    drop_table :user_courses
  end
end
