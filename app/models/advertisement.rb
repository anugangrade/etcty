class Advertisement < ActiveRecord::Base
  	has_many :adv_branches
	has_many :branches, :through => :adv_branches

  	has_many :adv_zones
	has_many :zones, :through => :adv_zones
  	
	belongs_to :user

	has_attached_file :image, :styles => {:thumbnail => "500x380>", :medium => "300x300>", :thumb => "100x100>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  	def self.all_sub_categories
  		self.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.uniq
  	end
end
