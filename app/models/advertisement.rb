class Advertisement < ActiveRecord::Base
	has_many :branch_connects, as: :connectable
	has_many :branches, through: :branch_connects
	accepts_nested_attributes_for :branch_connects

  has_many :adv_zones, dependent: :destroy
	has_many :zones, :through => :adv_zones
	accepts_nested_attributes_for :adv_zones

  has_many :transactions, :as => :purchasable, dependent: :destroy
  	
	belongs_to :user

	has_attached_file :image, :styles => {:thumbnail => "550x380>", :medium => "300x300>", :thumb => "100x100>", :tiny=>"50x50>" }, :default_url => "missing.png"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :running, lambda {|country| where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()").joins(:branches).where("branches.country"=> country) }


	def self.all_sub_categories
		all.collect(&:branches).flatten.uniq.collect(&:branchable).uniq.collect(&:sub_categories).flatten.uniq
	end

	def expired?
		self.end_date < Date.today
	end
end
