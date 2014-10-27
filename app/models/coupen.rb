class Coupen < ActiveRecord::Base
	has_many :coupen_connects
	has_many :coupen_types, :through => :coupen_connects

	has_many :coupen_branches
	has_many :branches, :through => :coupen_branches

	belongs_to :user

	has_attached_file :image, :styles => {:medium => "351x160>", :thumb => "100x100>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  	scope :running, lambda { where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()") }


  	def self.all_sub_categories
  		self.all.running.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.uniq
  	end
  	

end
