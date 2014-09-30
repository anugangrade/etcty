class SaleBranch < ActiveRecord::Base
	belongs_to :sale
	belongs_to :branch
end
