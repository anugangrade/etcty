class Zone < ActiveRecord::Base
	has_many :adv_zones
	has_many :advertisements, :through => :adv_zones
  	
end
