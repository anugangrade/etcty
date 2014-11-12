class DealType < ActiveRecord::Base
	has_many :deal_connects, dependent: :destroy
	has_many :deals, :through => :deal_connects
	
	default_scope { order('id') }

	def deals_within_today(country)
		self.deals.running(country)
	end
end
