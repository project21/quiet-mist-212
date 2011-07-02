class CreateStrengths < ActiveRecord::Migration
  def change
    create_table :strengths do |t|
      t.string :subject
      t.string :topic
      t.text :details

      t.timestamps
    end
  end
end
