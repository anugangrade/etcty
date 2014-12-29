class TemplateImage < ActiveRecord::Base
	def look_types
		["rounded", "circle", "thumbnail"]
	end
end
