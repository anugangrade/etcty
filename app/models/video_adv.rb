class VideoAdv < ActiveRecord::Base
	belongs_to :user

	has_many :branch_connects, as: :connectable
	has_many :branches, through: :branch_connects
	accepts_nested_attributes_for :branch_connects


	has_many :transactions, :as => :purchasable, dependent: :destroy

	scope :running, lambda {|country| where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()").joins(:branches).where("branches.country"=> country) }

	def self.all_sub_categories
  		all.collect(&:branches).flatten.uniq.collect(&:branchable).uniq.collect(&:sub_categories).flatten.uniq
  	end

  	def expired?
		self.end_date < Date.today
	end

end
