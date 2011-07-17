class AddUserCourses < ActiveRecord::Migration
  def up
    create_table :user_courses do |t|
      t.integer :user_id, :null => false,:default => 1
      t.integer :course_id, :null => false,:default => 1
      t.boolean :active, :null => false,:default => 1
    end
  end

  def down
    drop_table :user_courses
  end
end
