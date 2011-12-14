class ClassMembership < ActiveRecord::Base
	belongs_to :class_group
	belongs_to :user
end
