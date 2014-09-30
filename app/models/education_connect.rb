class EducationConnect < ActiveRecord::Base
	belongs_to :education
	belongs_to :education_type
end
