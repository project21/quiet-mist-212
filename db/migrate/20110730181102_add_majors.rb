class AddMajors < ActiveRecord::Migration
  def up
    create_table :majors do |t|
      t.string :name
      t.bool :other, :null => false, :default => false
      t.timestamps
    end
  end

  def down
    drop_table :majors
  end
end
