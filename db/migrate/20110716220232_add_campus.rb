class AddCampus < ActiveRecord::Migration
  def up
    create_table :schools do |t|
      t.string :name, :null => false ,:default => 1
      t.integer :postal_code, :null => false,:default => 1
      t.integer :location_id
    end

    change_table :users do |t|
      t.integer :school_id, :null => false,:default => 1
    end

    change_table :courses do |t|
      t.integer :school_id, :null => false,:default => 1
    end
  end

  def down
    drop_table :schools

    remove_column :users, :school_id
    remove_column :courses, :school_id
  end
end
