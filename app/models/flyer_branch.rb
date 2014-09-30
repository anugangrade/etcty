class FlyerBranch < ActiveRecord::Base
	belongs_to :flyer
	belongs_to :branch
end
