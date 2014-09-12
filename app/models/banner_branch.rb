class BannerBranch < ActiveRecord::Base
	belongs_to :banner
	belongs_to :branch
end
