class User < ActiveRecord::Base
  has_many :book_ownerships
  has_many :books, :through => :book_ownerships
  has_many :strong_ins
  has_many :weak_ins
  #has_and_belongs_to_many :courses

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,:firstname,:lastname,:school,:major,:sex,:zipcode
  
  def full_name
    [current_user.firstname,current_user.lastname].join("")
  end
end
