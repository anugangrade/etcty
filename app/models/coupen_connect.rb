class CoupenConnect < ActiveRecord::Base
	belongs_to :coupen
	belongs_to :coupen_type
end
