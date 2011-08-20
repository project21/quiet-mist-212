class AddImageUrlToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :image_url
    end
  end

  def down
    remove_column :users, :image_url

  end
end
