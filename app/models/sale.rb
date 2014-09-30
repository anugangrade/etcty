class Sale < ActiveRecord::Base
	belongs_to :user

	has_many :sale_branches
	has_many :branches, :through => :sale_branches

	has_many :sale_connects
	has_many :sale_types, :through => :sale_connects

	has_attached_file :image, :styles => { :thumbnail =>"728x100>", :medium => "300x300>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  	def self.all_sub_categories
  		self.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.uniq
  	end
  	
end
