class Banner < ActiveRecord::Base
	belongs_to :user

	has_many :banner_branches
	has_many :branches, :through => :banner_branches

	has_attached_file :image, :styles => { :thumbnail =>"728x100>", :medium => "300x300>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end
