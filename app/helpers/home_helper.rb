module HomeHelper
	def search_into_everything(params, branches)
	    branches.flatten.each do |branch|
	      @advertisements << branch.advertisements.where("title LIKE ?", "%#{params['search']}%")
	      @deals << branch.deals.where("title LIKE ?", "%#{params['search']}%")
	      @banners << branch.banners.where("title LIKE ?", "%#{params['search']}%")
	    end
	end

	def categories_having_data
		categories = Advertisement.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.collect(&:category).uniq
		categories << Deal.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.collect(&:category).uniq
		categories << Banner.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.collect(&:category).uniq
		return categories.flatten.uniq
	end
end
