class Banner < ActiveRecord::Base
	belongs_to :user

	has_attached_file :image, :styles => { :thumbnail =>"728x100>", :medium => "300x300>", :tiny=>"50x50>" }, :default_url => "missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :running, lambda { where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()") }

  def expired?
		self.end_date < Date.today
	end
	
end
