class SaleConnect < ActiveRecord::Base
	belongs_to :sale, touch: true
	belongs_to :sale_type, touch: true

	scope :if_checked, -> { where(checked: true) }

end
