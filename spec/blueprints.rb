require 'machinist/active_record'

School.blueprint do
  name { "State University" }
  postal_code { 95816 }
end

User.blueprint do
  email { "#{sn}@example.com" }
  password {'secret' }
  password_confirmation { 'secret' }
  firstname { "First" }
  lastname { "Last" }
  school_id { School.make!.id }
end

Book.blueprint do
  title   { "Physics" }
  author  { "Weber" }
  edition { '1' }
end

BookOwnership.blueprint do
  user { User.make! }
  book { Book.make! }
end

Course.blueprint do
  school_id { School.make!.id }
  subject { "Course 1" }
end

UserCourse.blueprint do
  active { true }
  user_id { User.make!.id }
  course_id { Course.make!.id }
end

def make_post!
  uc = UserCourse.make!
  Post.make! :user_id => uc.user_id, :course_id => uc.course_id
  uc
end

Post.blueprint do
  content { "Posting..." }
end
