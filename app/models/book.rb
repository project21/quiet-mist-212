class Book < ActiveRecord::Base
   col :title,      as: :string
   col :author,     as: :string
   col :created_at, as: :timestamp
   col :updated_at, as: :timestamp
   col :edition,    as: :string
   col :isbn,       as: :string, null:false

  has_many :book_ownerships
  has_many :users, :through => :book_ownerships

  validates_presence_of :author, :title
end
