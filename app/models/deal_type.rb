class DealType < ActiveRecord::Base
	has_many :deal_connects
	has_many :deals, :through => :deal_connects

	default_scope { order('id') }

	def deals_within_today
		self.deals.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end
end
