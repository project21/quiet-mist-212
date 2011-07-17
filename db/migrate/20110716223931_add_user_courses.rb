class AddUserCourses < ActiveRecord::Migration
  def up
    create_table :user_courses do |t|
      t.integer :user_id, :null => false
      t.integer :course_id, :null => false
      t.boolean :active, :null => false
    end
  end

  def down
    drop_table :user_courses
  end
end
