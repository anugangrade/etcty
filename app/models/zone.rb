class Zone < ActiveRecord::Base
	has_many :adv_zones
	has_many :advertisements, :through => :adv_zones
  	
 	default_scope { order('id') }

	def advs_within_today
		self.advertisements.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end

end	
