class CreatePostAttachment < ActiveRecord::Migration
  def up
    drop_table :strengths
    drop_table :weaknesses
    PostAttachment.auto_upgrade!
  end

  def down
    create_table :strengths
    create_table :weaknesses
    drop_table :post_attachments
  end
end
