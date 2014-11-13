class Store < ActiveRecord::Base
	belongs_to :user
	belongs_to :sub_category

	has_many :branches, dependent: :destroy
	accepts_nested_attributes_for :branches
	
	has_many :store_sub_categories, dependent: :destroy
	has_many :sub_categories, :through => :store_sub_categories

	has_attached_file :image, :styles => {:thumbnail => "500x380>", :medium => "300x300>", :thumb => "100x100>", :tiny=>"50x50>" }, :default_url => "default-logo.jpg"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  	scope :within_country, lambda {|country| joins(:branches).where("branches.country"=> country) }

  	def self.all_sub_categories
  		self.all.collect(&:sub_categories).flatten.uniq
  	end
  	
  	def to_param
	    "#{id}-#{name}"
	  end
end
