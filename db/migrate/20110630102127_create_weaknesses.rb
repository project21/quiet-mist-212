class CreateWeaknesses < ActiveRecord::Migration
  def change
    create_table :weaknesses do |t|
      t.string :subject
      t.string :topic
      t.text :details

      t.timestamps
    end
  end
end
