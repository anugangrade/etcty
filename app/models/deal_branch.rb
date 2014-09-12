class DealBranch < ActiveRecord::Base
	belongs_to :deal
	belongs_to :branch
end
