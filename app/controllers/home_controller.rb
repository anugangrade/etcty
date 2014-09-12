class HomeController < ApplicationController
  def index
  	@zones = Zone.all.limit(9)
  	@deal_types = DealType.all.limit(4)
  end

  def profile
  	@user = User.find_by_username(params[:username])

  	@stores = @user.stores
  	@advertisements = @user.advertisements
    @deals = @user.deals
  	@banners = @user.banners
  	
  end
end
