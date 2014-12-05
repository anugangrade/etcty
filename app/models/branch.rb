class Branch < ActiveRecord::Base
	scope :in_location, lambda { |location| where("city LIKE ? OR zip LIKE ? ", location["city"], location["zip"] ) }
	belongs_to :branchable, :polymorphic => true

	has_many :branch_connects, dependent: :destroy
	has_many :advertisements, :through => :branch_connects

	has_many :deal_branches, dependent: :destroy
	has_many :deals, :through => :deal_branches

	has_many :sale_branches, dependent: :destroy
	has_many :sales, :through => :sale_branches

	has_many :education_branches, dependent: :destroy
	has_many :educations, :through => :education_branches

	has_many :flyer_branches, dependent: :destroy
	has_many :flyers, :through => :flyer_branches

	has_many :video_adv_branches, dependent: :destroy
	has_many :video_advs, :through => :video_adv_branches

	has_many :coupen_branches, dependent: :destroy
	has_many :coupens, :through => :coupen_branches

	has_many :tutorial_branches, dependent: :destroy
	has_many :tutorials, :through => :tutorial_branches


end
