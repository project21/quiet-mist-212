class PostAttachment < ActiveRecord::Base
  col :post_id,    as: :integer, null:false
  col :attachment, as: :string,  null:false

  belongs_to :post
  validates_presence_of :attachment

  attr_protected :post_id

  mount_uploader :attachment, CampusUploader
end
