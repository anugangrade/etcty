class SaleType < ActiveRecord::Base
	has_many :sale_connects, dependent: :destroy
	has_many :sales, :through => :sale_connects

	translates :name
	default_scope { includes(:translations) }
	
	default_scope { order('id') }
	
	def sales_within_today(country)
		self.sales.merge(SaleConnect.if_checked).running(country)
	end
end
