class InstituteSubCategory < ActiveRecord::Base
	belongs_to :institute
	belongs_to :sub_category
end
