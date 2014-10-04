module HomeHelper
	def search_into_everything(params, branches)
	    branches.flatten.each do |branch|
	      @advertisements << branch.advertisements.where("title LIKE ?", "%#{params['search']}%")
	      @deals << branch.deals.where("title LIKE ?", "%#{params['search']}%")
	      # @banners << branch.banners.where("title LIKE ?", "%#{params['search']}%")
	      @sales << branch.sales.where("title LIKE ?", "%#{params['search']}%")
	      @educations << branch.educations.where("title LIKE ?", "%#{params['search']}%")
	      @flyers << branch.flyers.where("title LIKE ?", "%#{params['search']}%")
	      @video_advs << branch.video_advs.where("title LIKE ?", "%#{params['search']}%")
	    end
	end
end
