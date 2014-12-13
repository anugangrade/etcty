class EducationType < ActiveRecord::Base
	has_many :education_connects, dependent: :destroy
	has_many :educations, :through => :education_connects

	default_scope { order('id') }
	translates :name
	default_scope { includes(:translations) }
	
	def educations_within_today(country)
		self.educations.merge(EducationConnect.if_checked).running(country)
	end
end
