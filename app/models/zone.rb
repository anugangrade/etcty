class Zone < ActiveRecord::Base
	has_many :adv_zones, dependent: :destroy
	has_many :advertisements, :through => :adv_zones

	translates :name

 	default_scope { order('id') }

	def advs_within_today(country)
		self.advertisements.running(country)
	end

end	
