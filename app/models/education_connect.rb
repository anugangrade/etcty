class EducationConnect < ActiveRecord::Base
	belongs_to :education, touch: true
	belongs_to :education_type, touch: true

	scope :if_checked, -> { where(checked: true) }
end
