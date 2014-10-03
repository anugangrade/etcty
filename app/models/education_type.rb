class EducationType < ActiveRecord::Base
	has_many :education_connects
	has_many :educations, :through => :education_connects

	default_scope { order('id') }

	def educations_within_today
		self.educations.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end
end
