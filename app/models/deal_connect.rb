class DealConnect < ActiveRecord::Base
	belongs_to :deal
	belongs_to :deal_type

	scope :if_checked, -> { where(checked: true) }
end
