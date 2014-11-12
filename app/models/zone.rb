class Zone < ActiveRecord::Base
	has_many :adv_zones, dependent: :destroy
	has_many :advertisements, :through => :adv_zones

 	default_scope { order('id') }

	def advs_within_today(country)
		self.advertisements.running(country)
	end

end	
