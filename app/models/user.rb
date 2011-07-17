class User < ActiveRecord::Base
  belongs_to :school

  has_many :posts
  has_many :user_courses
  has_many :courses, :through => :user_courses

  has_many :book_ownerships
  has_many :books, :through => :book_ownerships

  has_many :authentications

  has_many :strengths
  has_many :weaknesses

  #has_and_belongs_to_many :courses
  validates_presence_of :firstname, :lastname
  validates_presence_of :school_id, :if => :registered?

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  def password_required?  
    (authentications.empty? || !password.blank?) && super  
  end  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,:firstname,:lastname,:school,:major,:sex,:zipcode
  
  def full_name
    [current_user.firstname,current_user.lastname].join("")
  end

  def apply_omniauth(omniauth)  
    self.email ||= omniauth['user_info']['email']
    nick = omniauth['user_info']['nickname']
    self.username ||= nick
    case omniauth['provider']
    when 'twitter'  then self.twitter_handle = nick
    when 'facebook' then self.facebook_uid = omniauth['uid']
    end
    authentications.build(:provider => omniauth['provider'],
                          :uid => omniauth['uid'],
                          :token => omniauth['credentials']['token'],
                          :secret => omniauth['credentials']['secret']
                         )
  end  

  def self.from_omniauth(omniauth)
    if a = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])  
      return a.user
    end
    User.new.apply_omniauth omniauth
  end
end
