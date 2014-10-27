class DealType < ActiveRecord::Base
	has_many :deal_connects
	has_many :deals, :through => :deal_connects
	
	default_scope { order('id') }

	def deals_within_today
		self.deals.running
	end
end
