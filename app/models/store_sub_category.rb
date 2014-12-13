class StoreSubCategory < ActiveRecord::Base
	belongs_to :store, touch: true
	belongs_to :sub_category, touch: true
end
