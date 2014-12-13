class DealConnect < ActiveRecord::Base
	belongs_to :deal, touch: true
	belongs_to :deal_type, touch: true

	scope :if_checked, -> { where(checked: true) }
end
