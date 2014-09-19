module HomeHelper
	def deals_within_today(deal_type)
		deal_type.deals.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end

	def advs_within_today(zone)
		zone.advertisements.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
	end

	def search_into_everything(params, branches)
	    branches.flatten.each do |branch|
	      @advertisements << branch.advertisements.where("title LIKE ?", "%#{params['search']}%")
	      @deals << branch.deals.where("title LIKE ?", "%#{params['search']}%")
	      @banners << branch.banners.where("title LIKE ?", "%#{params['search']}%")
	    end
	end
end
