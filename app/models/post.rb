class Post < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

=begin
  POST_TYPES = %w(help)
  belongs_to :post_type, :polymorphic => true
=end

  validates_presence_of :user_id, :course_id, :content

  scope :for_user, ->(user){ where(:course_id => user.course_ids) }

  validate :valid_course_id, :if => :course_id

  def valid_course_id
    unless user.course_ids.include? course_id.to_i
      errors.add :course_id, "must be a course you are taking"
      return false
    end
  end
end
