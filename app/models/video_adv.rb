class VideoAdv < ActiveRecord::Base
	belongs_to :user

	has_many :video_adv_branches, dependent: :destroy
	has_many :branches, :through => :video_adv_branches

	has_many :transactions, :as => :purchasable, dependent: :destroy


	scope :running, lambda { where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()") }

	def self.all_sub_categories
  		self.all.running.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.uniq
  	end

  	def expired?
		self.end_date < Date.today
	end

end
