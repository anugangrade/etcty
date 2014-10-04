class VideoAdv < ActiveRecord::Base
	belongs_to :user

	has_many :video_adv_branches
	has_many :branches, :through => :video_adv_branches

	def self.all_sub_categories
  		self.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.uniq
  	end


  	def self.within_today
		self.all.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end
end
