class CreateClassGroups < ActiveRecord::Migration
  def change
    create_table :class_groups do |t|
      t.string :crn
      t.string :professor
      t.text :objective
      t.integer :course_id

      t.timestamps
    end
  end
end
