module HomeHelper
	def search_into_everything(params, branches)
	    branches.flatten.each do |branch|
	      @advertisements << branch.advertisements.merge(BranchConnect.if_checked).where("title LIKE ?", "%#{params['search']}%")
	      @deals << branch.deals.merge(BranchConnect.if_checked).where("title LIKE ?", "%#{params['search']}%")
	      # @banners << branch.banners.where("title LIKE ?", "%#{params['search']}%")
	      @sales << branch.sales.merge(BranchConnect.if_checked).where("title LIKE ?", "%#{params['search']}%")
	      @educations << branch.educations.merge(BranchConnect.if_checked).where("title LIKE ?", "%#{params['search']}%")
	      @flyers << branch.flyers.merge(BranchConnect.if_checked).where("title LIKE ?", "%#{params['search']}%")
	      @video_advs << branch.video_advs.merge(BranchConnect.if_checked).where("title LIKE ?", "%#{params['search']}%")
	      @coupens << branch.coupens.merge(BranchConnect.if_checked).where("title LIKE ?", "%#{params['search']}%")
	    end
	end
end
