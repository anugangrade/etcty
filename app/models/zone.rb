class Zone < ActiveRecord::Base
	has_many :adv_zones
	has_many :advertisements, :through => :adv_zones

 	default_scope { order('id') }

	def advs_within_today
		self.advertisements.running
	end

end	
