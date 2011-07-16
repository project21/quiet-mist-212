class AddCourseIdToPosts < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.integer :user_id
      t.integer :course_id

      t.string :post_type
      t.integer :post_type_id

      t.text :content_data
    end
  end

  def down
    remove_column :posts, :user_id, :course_id, :post_type, :post_type_id, :content_data
  end
end
