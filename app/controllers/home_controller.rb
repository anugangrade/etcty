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

  def category_sub
    @SubCategory = SubCategory.where("name like ?", "%#{params[:q]}%")
    render :json => @SubCategory.map {|f| {:id=> f.id, :name=> "#{f.name}-#{f.category.name}"} }
  end

  def search_result
    # @category = Category.find(params["category_id"])
    # @stores = @category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
    # @branches = @stores.collect(&:branches).flatten.uniq
    # @advertisements = @branches.collect(&:advertisements).flatten.uniq
    # @deals = @branches.collect(&:deals).flatten.uniq
    # @banners = @branches.collect(&:banners).flatten.uniq

  end 
end
