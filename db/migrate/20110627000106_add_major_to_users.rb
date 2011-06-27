class AddMajorToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :major, :string
  end

  def self.down
    remove_column :users, :major
  end
end
