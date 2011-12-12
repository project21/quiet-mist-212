class User < ActiveRecord::Base
  col :email,                as: :string
  col :encrypted_password,   as: :string,   null:false
  #col :password_salt,        as: :string,   null:false
  col :reset_password_token, as: :string
  col :remember_token,       as: :string
  col :remember_created_at,  as: :timestamp
  col :sign_in_count,        as: :integer,  default: 0
  col :current_sign_in_at,   as: :timestamp
  col :current_sign_in_ip,   as: :string
  col :last_sign_in_at,      as: :timestamp
  col :last_sign_in_ip,      as: :string
  col :created_at,           as: :timestamp
  col :updated_at,           as: :timestamp
  col :firstname,            as: :string
  col :lastname,             as: :string
  col :major,                as: :string
  col :sex,                  as: :string
  col :zipcode,              as: :integer
  col :highschool,           as: :string
  col :registered,           as: :boolean
  col :school_id,            as: :integer
  col :image_url,            as: :string
  col :photo,                as: :string
  col :confirmed_at,         as: :timestamp
  col :confirmation_sent_at, as: :timestamp
  col :confirmation_token,   as: :string

  belongs_to :school
  delegate :name, :to => :school, :prefix => true, :allow_nil => true

  has_many :posts
  has_many :user_courses
  has_many :courses, :through => :user_courses
  has_many :active_courses, :through => :user_courses, :source => :course, :conditions => {'user_courses.active' => true}
  has_many :taken_courses, :through => :user_courses, :source => :course, :conditions => {'user_courses.active' => false}

  has_many :book_ownerships
  has_many :books, :through => :book_ownerships

  has_many :authentications

  has_many :strengths
  has_many :weaknesses
  mount_uploader :photo,PhotoUploader
  #has_and_belongs_to_many :courses
  validates_presence_of :firstname, :lastname
  validates_presence_of :school_id, :if => :registered?
  validates_presence_of :highschool ,:if=> :registered?
  validates_uniqueness_of :email, :if => :email

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :omniauthable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def email_required?; password_required? end

  def password_required?
    (authentications.empty? || !password.blank?) && super  
  end  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,:firstname,:lastname,:major,:image_url,:photo, :highschool, :remember_me

  # for form
  attr_reader :major_id

  def set_school_id sid
    s_id = sid.to_i
    if s_id <= 0 || school_id
      errors.add "school_id", "could not set to #{s_id}"
      return nil
    else
      self.school_id = s_id
    end
  end

  def avatar_url; photo_url || image_url end

  def register!
    self.registered = true
    save
  end
  
  def full_name
    [current_user.firstname,current_user.lastname].join("")
  end

  def apply_omniauth(omniauth)  
    extra = omniauth["extra"] || {'user_hash' => {}}
    if email.blank?
      # not sure if the extra part is needed or not
      self.email ||= omniauth['user_info']['email'] || extra["user_hash"]["email"]
    end

    self.lastname  = omniauth['user_info']['last_name']  if lastname.blank?
    self.firstname = omniauth['user_info']['first_name'] if firstname.blank?
    fname, lname = (omniauth['user_info']['name'] || extra["user_hash"]["name"] || '').split(/\s+/)
    self.firstname = fname if firstname.blank?
    self.lastname = lname  if lastname.blank?
    
    if profile_image_url = omniauth['user_info']['image'] || extra["user_hash"]["profile_image_url"]
      self.image_url = profile_image_url if profile_image_url != image_url
    end

    authentications.build(:provider => omniauth['provider'],
                          :uid => omniauth['uid'],
                          :token => omniauth['credentials']['token'],
                          :secret => omniauth['credentials']['secret']
                         )
  end  

  def self.from_omniauth(omniauth, current_user)
    (if current_user and a = current_user.authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])  
      a.user
    end || current_user || User.new).tap {|u| u.apply_omniauth omniauth }
  end
end
