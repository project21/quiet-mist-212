class AddReplyIdToPost < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.integer :reply_id
    end
  end
end
