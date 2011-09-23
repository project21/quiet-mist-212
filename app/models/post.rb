class Post < ActiveRecord::Base
  attr_protected :user_id

  belongs_to :course
  belongs_to :user

  has_many :post_attachments

  has_many :replies, :class_name => 'Post', :foreign_key => :reply_id

=begin
  POST_TYPES = %w(help)
  belongs_to :post_type, :polymorphic => true
=end

  validates_presence_of :user_id, :course_id, :content

  scope :for_user, ->(user){ where(:course_id => user.course_ids) }
  scope :top_level, where(reply_id: nil)

  validate :valid_course_id, :if => :course_id

  after_create :set_course_ids

  def valid_course_id
    unless user.course_ids.include? course_id.to_i
      errors.add :course_id, "must be a course you are taking"
      return false
    end
  end

  # A post can be for multiple courses.
  # Rather than create a join table we duplicate the Post for each course.
  def set_course_ids
    return unless course_ids.present?

    (course_ids.map(&:to_i) - [course_id]).compact.each do |course_id|
      self.class.create attributes.merge(:course_id => course_id, :user => user)
    end
  end

  attr_accessor :course_ids

  def course_id= course_ids
    case course_ids
    when Array
      super(course_ids.shift).tap do
        self.course_ids = course_ids.map(&:to_i)
      end
    else
      super course_ids
    end
  end
end
