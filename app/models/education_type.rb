class EducationType < ActiveRecord::Base
	has_many :education_connects, dependent: :destroy
	has_many :educations, :through => :education_connects

	default_scope { order('id') }

	def educations_within_today(country)
		self.educations.running(country)
	end
end
