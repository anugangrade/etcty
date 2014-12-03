class AdvZone < ActiveRecord::Base
	belongs_to :zone
	belongs_to :advertisement

	scope :if_checked, -> { where(checked: true) }

end
