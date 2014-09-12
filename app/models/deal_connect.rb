class DealConnect < ActiveRecord::Base
	belongs_to :deal
	belongs_to :deal_type
end
