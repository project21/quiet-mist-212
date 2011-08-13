class ChangeSubjectToName < ActiveRecord::Migration
  def up
    rename_column :courses, :subject, :name
  end

  def down
    rename_column :courses, :name, :subject
  end
end
