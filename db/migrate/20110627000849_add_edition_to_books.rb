class AddEditionToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :edition, :string
  end

  def self.down
    remove_column :books, :edition
  end
end
