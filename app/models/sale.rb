class Sale < ActiveRecord::Base
	belongs_to :user

	has_many :sale_branches
	has_many :branches, :through => :sale_branches

	has_many :sale_connects
	has_many :sale_types, :through => :sale_connects

	has_many :transactions, :as => :purchasable

	has_attached_file :image, :styles => {:medium => "300x300>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  	scope :running, lambda { where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()") }

  	def self.all_sub_categories
  		self.all.running.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.uniq
  	end
  	
end
