class CoupenType < ActiveRecord::Base
	has_many :coupen_connects, dependent: :destroy
	has_many :coupens, :through => :coupen_connects

	default_scope { order('id') }

	def coupens_within_today
		self.coupens.running
	end
end
