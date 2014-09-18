class Store < ActiveRecord::Base
	belongs_to :user
	belongs_to :sub_category

	has_many :branches
	accepts_nested_attributes_for :branches
	
	has_many :store_sub_categories
	has_many :sub_categories, :through => :store_sub_categories
  	
end
