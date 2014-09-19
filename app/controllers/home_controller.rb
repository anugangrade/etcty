class HomeController < ApplicationController
  include HomeHelper
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
    @advertisements = []
    @deals = []
    @banners = []
    branches = []

    if params["category_id"].present?
      @category = Category.find(params["category_id"])
      stores = @category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq

      stores.each do |store|
        branches << store.branches.where("address LIKE ? OR city LIKE ? OR state LIKE ? OR country LIKE ? OR zip LIKE ? ", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%")
      end
      search_into_everything(params, branches)
    end

    if params["store_ids"].present?
      params["store_ids"].each do |store_id|
        store = Store.find(store_id)
        branches << store.branches.where("address LIKE ? OR city LIKE ? OR state LIKE ? OR country LIKE ? OR zip LIKE ? ", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%")
      end
      search_into_everything(params, branches)
    end

    if params["zone_ids"].present?
      params["zone_ids"].each do |zone_id|
        zone = Zone.find(zone_id)
        @advertisements << zone.advertisements
      end
    end

    @advertisements = @advertisements.flatten.uniq
    @deals = @deals.flatten.uniq
    @banners = @banners.flatten.uniq

    if params["store_ids"].present? || params["zone_ids"].present?
      respond_to do |format|
        format.js
      end
    end
  end 
end
