class AddCampus < ActiveRecord::Migration
  def up
    create_table :campuses do |t|
      t.string :name
      t.integer :postal_code
      t.integer :location_id
    end

    change_table :users do |t|
      t.integer :campus_id
    end

    change_table :courses do |t|
      t.integer :campus_id
    end
  end

  def down
    drop_table :campuses

    remove_column :users, :campus_id
    remove_column :courses, :campus_id
  end
end
