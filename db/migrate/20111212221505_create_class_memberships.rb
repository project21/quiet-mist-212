class CreateClassMemberships < ActiveRecord::Migration
  def change
    create_table :class_memberships do |t|
      t.integer :user_id
      t.integer :class_group_id
      t.string :status
      t.boolean :moderator ,:default=>false
      t.boolean :instructor,:default=>false

      t.timestamps
    end
  end
end
