module HomeHelper
	def deals_within_today(deal_type)
		deal_type.deals.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order("RANDOM()")
	end

	def advs_within_today(zone)
		zone.advertisements.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).order("RANDOM()")
	end
end
