class AddZipcodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :zipcode, :integer
  end

  def self.down
    remove_column :users, :zipcode
  end
end
