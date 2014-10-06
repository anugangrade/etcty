class Branch < ActiveRecord::Base
	scope :in_location, lambda { |location| where("city LIKE ? OR zip LIKE ? ", location["city"], location["zip"] ) }


	belongs_to :store

	has_many :adv_branches
	has_many :advertisements, :through => :adv_branches

	has_many :deal_branches
	has_many :deals, :through => :deal_branches

	has_many :banner_branches
	has_many :banners, :through => :banner_branches

	has_many :sale_branches
	has_many :sales, :through => :sale_branches

	has_many :education_branches
	has_many :educations, :through => :education_branches

	has_many :flyer_branches
	has_many :flyers, :through => :flyer_branches

	has_many :video_adv_branches
	has_many :video_advs, :through => :video_adv_branches

	has_many :coupen_branches
	has_many :coupens, :through => :coupen_branches


end
