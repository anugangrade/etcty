class TemplateFont < ActiveRecord::Base

	def positions
		["left", "right", "center"]
	end

	def sizes
		["small", "medium", "large", "x-large", "xx-large", "smaller", "larger", "x-small", "xx-small"]
	end

	def styles
		["italic", "normal", "oblique"]
	end

	def weights
		["100", "200", "300", "400", "500", "600", "700", "800", "900", "bold", "bolder", "lighter", "normal"]
	end

	def text_decorations
		["blink", "line-through", "overline", "underline", "none"]
	end
end
