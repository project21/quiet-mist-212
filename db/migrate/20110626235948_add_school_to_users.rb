class AddSchoolToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :school, :string
  end

  def self.down
    remove_column :users, :school
  end
end
