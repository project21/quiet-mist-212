# encoding: utf-8
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

File.readlines('db/seeds/schools.txt').each do |school|
  School.find_or_create_by_name school.chomp
end

File.readlines('db/seeds/majors.txt').each do |major|
  Major.find_or_create_by_name major.chomp
end
