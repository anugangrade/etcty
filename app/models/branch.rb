class Branch < ActiveRecord::Base
	scope :in_location, lambda { |location| where("city LIKE ? OR zip LIKE ? ", location["city"], location["zip"] ) }
	belongs_to :branchable, :polymorphic => true
	
	has_many :branch_connects
	has_many :advertisements, :through => :branch_connects, :source => :connectable, :source_type => "Advertisement"
	has_many :deals, :through => :branch_connects, :source => :connectable, :source_type => "Deal"
	has_many :sales, :through => :branch_connects, :source => :connectable, :source_type => "Sale"
	has_many :flyers, :through => :branch_connects, :source => :connectable, :source_type => "Flyer"
	has_many :video_advs, :through => :branch_connects, :source => :connectable, :source_type => "VideoAdv"
	has_many :coupens, :through => :branch_connects, :source => :connectable, :source_type => "Coupen"
	has_many :tutorials, :through => :branch_connects, :source => :connectable, :source_type => "Tutorial"
	has_many :educations, :through => :branch_connects, :source => :connectable, :source_type => "Education"

end
