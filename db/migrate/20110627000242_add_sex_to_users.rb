class AddSexToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sex, :string
  end

  def self.down
    remove_column :users, :sex
  end
end