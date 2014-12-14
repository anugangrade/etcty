class EducationConnect < ActiveRecord::Base
	belongs_to :education
	belongs_to :education_type

	scope :if_checked, -> { where(checked: true) }
end
