class CreateBookOwnerships < ActiveRecord::Migration
  
  def self.up
    create_table :book_ownerships do |t|
      t.integer :book_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :book_ownerships
  end
end
