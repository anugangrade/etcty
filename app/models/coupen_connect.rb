class CoupenConnect < ActiveRecord::Base
	belongs_to :coupen, touch: true
	belongs_to :coupen_type, touch: true

	scope :if_checked, -> { where(checked: true) }

end
