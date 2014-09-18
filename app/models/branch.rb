class Branch < ActiveRecord::Base
	belongs_to :store

	has_many :adv_branches
	has_many :advertisements, :through => :adv_branches

	has_many :deal_branches
	has_many :deals, :through => :deal_branches

	has_many :banner_branches
	has_many :banners, :through => :banner_branches
end
