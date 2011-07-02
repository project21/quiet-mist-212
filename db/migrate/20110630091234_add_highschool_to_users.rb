class AddHighschoolToUsers < ActiveRecord::Migration
  def change
    add_column :users, :highschool, :string
  end
end
