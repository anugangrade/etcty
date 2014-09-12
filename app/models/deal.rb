class Deal < ActiveRecord::Base
	has_many :deal_connects
	has_many :deal_types, :through => :deal_connects

	has_many :deal_branches
	has_many :branches, :through => :deal_branches

	belongs_to :user

	has_attached_file :image, :styles => { :thumbnail => "500x380>", :medium => "300x300>", :thumb => "100x100>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end
