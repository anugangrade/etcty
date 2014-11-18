class SaleType < ActiveRecord::Base
	has_many :sale_connects, dependent: :destroy
	has_many :sales, :through => :sale_connects

	translates :name
	
	default_scope { order('id') }
	
	def sales_within_today(country)
		self.sales.running(country)
	end
end
