class AdvZone < ActiveRecord::Base
	belongs_to :zone, touch: true
	belongs_to :advertisement, touch: true

	scope :if_checked, -> { where(checked: true) }

end
