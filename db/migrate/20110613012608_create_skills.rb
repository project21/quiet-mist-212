class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.string :subject
      t.string :topic
      t.references :user 
      t.timestamps
    end
  end

  def self.down
    drop_table :skills
  end
end
