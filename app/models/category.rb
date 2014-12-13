class Category < ActiveRecord::Base
	has_many :sub_categories, dependent: :destroy

	translates :name

	default_scope { includes(:translations) }

	def get_institutes
  		self.sub_categories.collect(&:institutes).reject(&:blank?).flatten.uniq
  	end

  	def get_stores
  		self.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
  	end
  	
end
