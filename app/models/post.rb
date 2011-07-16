class Post < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  POST_TYPES = %w(help)
  belongs_to :post_type, :polymorphic => true

  validates_presence_of :content
end
