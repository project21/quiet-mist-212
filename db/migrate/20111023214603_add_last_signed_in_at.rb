class AddLastSignedInAt < ActiveRecord::Migration
  def change
    User.auto_upgrade!
  end
end
