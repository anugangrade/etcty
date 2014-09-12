class DealType < ActiveRecord::Base
	has_many :deal_connects
	has_many :deals, :through => :deal_connects
end
