class PostAttachment < ActiveRecord::Base
  col :post_id,    as: :integer, null:false
  col :attachment, as: :string,  null:false

  belongs_to :post

  mount_uploader :attachment, CampusUploader
end
