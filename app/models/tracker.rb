class Tracker < ActiveRecord::Base
	def increament_visit_count
		self.update_attributes(visits: self.visits+1)
	end
end
