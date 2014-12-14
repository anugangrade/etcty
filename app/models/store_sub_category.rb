class StoreSubCategory < ActiveRecord::Base
	belongs_to :store
	belongs_to :sub_category
end
