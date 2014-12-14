class SaleConnect < ActiveRecord::Base
	belongs_to :sale
	belongs_to :sale_type

	scope :if_checked, -> { where(checked: true) }

end
