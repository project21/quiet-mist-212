class User < ActiveRecord::Base
  belongs_to :campus

  has_many :posts
  has_many :user_courses
  has_many :courses, :through => :user_courses

  has_many :book_ownerships
  has_many :books, :through => :book_ownerships


  has_many :strengths
  has_many :weaknesses

  #has_and_belongs_to_many :courses
  validates_presence_of :firstname, :lastname, :school

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
