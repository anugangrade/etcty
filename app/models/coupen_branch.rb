class CoupenBranch < ActiveRecord::Base
	belongs_to :coupen
	belongs_to :branch
end
