class Store < ActiveRecord::Base
	belongs_to :user
	belongs_to :sub_category

	has_many :branches
	accepts_nested_attributes_for :branches

end
