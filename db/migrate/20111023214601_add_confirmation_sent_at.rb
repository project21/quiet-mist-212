class AddConfirmationSentAt < ActiveRecord::Migration
  def change
    User.connection.execute("ALTER TABLE users DROP COLUMN confirmed_at")
    User.auto_upgrade!
  end
end
