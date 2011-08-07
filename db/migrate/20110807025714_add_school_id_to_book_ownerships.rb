class AddSchoolIdToBookOwnerships < ActiveRecord::Migration
  def up
    add_column :book_ownerships, :school_id, :integer, :null => false
  end
  def down
    remove_column :book_ownerships, :school_id
  end
end
