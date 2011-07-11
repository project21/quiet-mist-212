require 'machinist/active_record'

User.blueprint do
  email { "#{sn}@example.com" }
  password {'secret' }
  password_confirmation { 'secret' }
end

Book.blueprint do
  title   { "Physics" }
  author  { "Weber" }
  edition { '1' }
end

BookOwnership.blueprint do
  user_id { User.make!.id }
  book_id { Book.make!.id }
end
