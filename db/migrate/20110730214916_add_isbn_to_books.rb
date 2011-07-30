class AddIsbnToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :isbn, :string, :null => false
    add_index :books, :isbn, :unique => true
  end

  def self.down
    remove_index :books, :column => :isbn
    remove_column :books, :isbn
  end
end
