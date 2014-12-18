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

	def share_with_facebook_url(opts)

    # Generates an url that will 'share with Facebook', and can includes title, url, summary, images without need of OG data.
    #
    # URL generate will be like
    # http://www.facebook.com/sharer.php?s=100&p[title]=We also do cookies&p[url]=http://www.wealsodocookies.com&p[images][0]=http://www.wealsodocookies.com/images/logo.jpg&p[summary]=Super developer company
    #
    # For this you'll need to pass the options as
    #
    # { :url     => "http://www.wealsodocookies.com",
    #   :title   => "We also do cookies",
    #   :images  => {0 => "http://imagelink"} # You can have multiple images here
    #   :summary => "My summary here"
    # }

    url = "http://www.facebook.com/sharer.php?s=100"

    parameters = []

    opts.each do |k,v|
      key = "p[#{k}]"

      if v.is_a? Hash
        v.each do |sk, sv|
          parameters << "#{key}[#{sk}]=#{sv}"
        end
      else
        parameters << "#{key}=#{v}"
      end

    end

    url + parameters.join("&")
	end

end
