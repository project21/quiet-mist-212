class AddCourseIdToBookOwnership < ActiveRecord::Migration
  def up
    add_column :book_ownerships, :course_id, :integer
  end

  def down
    remove_column :book_ownerships, :course_id
  end
end
