class CreateClassTakens < ActiveRecord::Migration
  def change
    create_table :class_takens do |t|
      t.string :class_name

      t.timestamps
    end
  end
end
