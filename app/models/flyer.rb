class Flyer < ActiveRecord::Base
	belongs_to :user

	has_many :flyer_branches, dependent: :destroy
	has_many :branches, :through => :flyer_branches

	has_many :transactions, :as => :purchasable, dependent: :destroy

	has_attached_file :image, :styles => { :medium => "300x300>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  	scope :running, lambda { where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()") }

  	def self.all_sub_categories
  		self.all.running.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.uniq
  	end

  	def expired?
		self.end_date < Date.today
	end

end
