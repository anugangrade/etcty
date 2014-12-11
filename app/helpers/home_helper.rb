module HomeHelper
	def search_into_everything(params, branches)
	    branches.flatten.each do |branch|
	      @advertisements << branch.advertisements.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	      @deals << branch.deals.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	      @sales << branch.sales.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	      @educations << branch.educations.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	      @flyers << branch.flyers.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	      @video_advs << branch.video_advs.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	      @coupens << branch.coupens.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	      @tutorials << branch.tutorials.merge(BranchConnect.if_checked).where("lower(title) LIKE ?", "%#{params['search'].downcase}%")
	    end
	end
end
