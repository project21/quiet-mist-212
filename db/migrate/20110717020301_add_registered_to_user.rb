class AddRegisteredToUser < ActiveRecord::Migration
  def up
    remove_column :users, :school_id, :school

    change_table :users do |t|
      t.boolean :registered
      t.integer :school_id
    end
  end

  def down
    remove_column :users, :registered
  end
end
