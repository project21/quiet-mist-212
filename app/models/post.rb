class Post < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  POST_TYPES = %w(help)
  belongs_to :post_type, :polymorphic => true

  validates_presence_of :content

  scope :for_user, ->(user){ where(:course_id => user.course_ids) }

  validate :valid_course_id, :if => :course_id

  def valid_course_id
    user.course_ids.include? course_id.to_i
  end
end
