class Branch < ActiveRecord::Base
	scope :in_location, lambda { |location| where("city LIKE ? OR zip LIKE ? ", location["city"], location["zip"] ) }
	belongs_to :branchable, :polymorphic => true
end
