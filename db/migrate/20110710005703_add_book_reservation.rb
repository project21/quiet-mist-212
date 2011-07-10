class AddBookReservation < ActiveRecord::Migration
  def self.up
    change_table :book_ownerships do |t|
      t.change :user_id, :integer, :null => false
      t.change :book_id, :integer, :null => false
      t.integer :reserver_id
      t.decimal :offer, :precision => 5, :scale => 2, :default => 0
      t.datetime :offered_at
      t.datetime :accepted_at
    end
  end

  def self.down
    remove_column :book_ownerships, :offer, :reserver_id, :offered_at, :accepted_at
  end
end
