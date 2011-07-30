class AddMajors < ActiveRecord::Migration
  def up
    create_table :majors do |t|
      t.string :name
      t.boolean :other, :null => false, :default => false
      t.timestamps
    end
    change_column :schools, :postal_code, :integer, :null => true
  end

  def down
    drop_table :majors
  end
end
