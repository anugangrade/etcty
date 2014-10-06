class CoupenType < ActiveRecord::Base
	has_many :coupen_connects
	has_many :coupens, :through => :coupen_connects

	default_scope { order('id') }

	def coupens_within_today
		self.coupens.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end
end
