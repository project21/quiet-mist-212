class ClassGroup < ActiveRecord::Base
	has_many :users ,:through=>:class_memberships
	has_many :class_memberships
	belongs_to :course
	accepts_nested_attributes_for :users
end
