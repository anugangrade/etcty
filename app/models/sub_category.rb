class SubCategory < ActiveRecord::Base
	belongs_to :category

	has_many :store_sub_categories, dependent: :destroy
	has_many :stores, :through => :store_sub_categories
  	
end
