class Template < ActiveRecord::Base
	belongs_to :templatable

	has_many :template_fonts
	accepts_nested_attributes_for :template_fonts

	has_many :template_images
	accepts_nested_attributes_for :template_images

	def positions
		["left", "right", "center"]
	end
	
	def image_types
		["rounded", "circle", "thumbnail"]
	end
end
