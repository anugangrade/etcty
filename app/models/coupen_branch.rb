class CoupenBranch < ActiveRecord::Base
	belongs_to :coupen, touch: true
	belongs_to :branch, touch: true
end
