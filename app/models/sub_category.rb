class SubCategory < ActiveRecord::Base
	belongs_to :category

	has_many :store_sub_categories, dependent: :destroy
	has_many :stores, :through => :store_sub_categories

	has_many :institute_sub_categories, dependent: :destroy
	has_many :institutes, :through => :institute_sub_categories
  	
end
