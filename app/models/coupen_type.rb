class CoupenType < ActiveRecord::Base
	has_many :coupen_connects, dependent: :destroy
	has_many :coupens, :through => :coupen_connects

	default_scope { order('id') }
	translates :name
	default_scope { includes(:translations) }
	
	def coupens_within_today(country)
		self.coupens.merge(CoupenConnect.if_checked).running(country)
	end
end
