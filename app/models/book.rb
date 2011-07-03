class Book < ActiveRecord::Base
  has_many :book_ownerships
  has_many :users, :through => :book_ownerships

  validates_presence_of :author, :title
end
