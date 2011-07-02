class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :reply_content

      t.timestamps
    end
  end
end
