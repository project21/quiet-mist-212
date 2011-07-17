class AddCampus < ActiveRecord::Migration
  def up
    return
    create_table :schools do |t|
      t.string :name, :null => false
      t.integer :postal_code, :null => false
      t.integer :location_id
    end

    change_table :users do |t|
      t.integer :campus_id, :null => false
    end

    change_table :courses do |t|
      t.integer :campus_id, :null => false
    end
  end

  def down
    drop_table :schools

    remove_column :users, :campus_id
    remove_column :courses, :campus_id
  end
end
