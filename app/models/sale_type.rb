class SaleType < ActiveRecord::Base
	has_many :sale_connects
	has_many :sales, :through => :sale_connects

	default_scope { order('id') }
	
	def sales_within_today
		self.sales.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end
end
