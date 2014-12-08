class DealType < ActiveRecord::Base
	has_many :deal_connects, dependent: :destroy
	has_many :deals, :through => :deal_connects
	
	default_scope { order('id') }
	translates :name
	
	def deals_within_today(country)
		self.deals.merge(DealConnect.if_checked).running(country)
	end
end
