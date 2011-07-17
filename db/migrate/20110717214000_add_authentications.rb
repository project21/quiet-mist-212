class AddAuthentications < ActiveRecord::Migration
  def up
    create_table :authentications do |t|
      t.integer :user_id, :null => false
      t.string :provider, :null => false
      t.string :uid
      t.string :token
      t.string :secret
    end
  end

  def down
    drop_table :authentications
  end
end
