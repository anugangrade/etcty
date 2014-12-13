class InstituteSubCategory < ActiveRecord::Base
	belongs_to :institute, touch: true
	belongs_to :sub_category, touch: true
end
