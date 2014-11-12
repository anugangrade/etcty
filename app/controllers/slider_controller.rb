class SliderController < ApplicationController
	def update_content
		case params["data1"]
		when "dealtype"
			@deal_type = DealType.find(params["data2"])
		when "banner"
			@banners = Banner.running
		when "video"
			@videos = VideoAdv.running(session[:country])
		when "coupentype"
			@coupen_type = CoupenType.find(params["data2"])
		when "zone"
			@zone = Zone.find(params["data2"])
		when "saletype"
			@sale_type = SaleType.find(params["data2"])
		when "educationtype"
			@education_type = EducationType.find(params["data2"])
		when "flyer"
			@flyers = Flyer.running(session[:country])
		end
	end
end
