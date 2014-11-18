class Category < ActiveRecord::Base
	has_many :sub_categories, dependent: :destroy

	translates :name
end
