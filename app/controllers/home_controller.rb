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

  def get_store
    store = Store.where("name like ?", "%#{params[:q]}%")
    render :json => store
  end

  def get_zone
    zone = Zone.where("name like ?", "%#{params[:q]}%")
    render :json => zone
  end

  def search_result
    @advertisements = []
    @deals = []
    @banners = []
    branches = []

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        @category = Category.find(params["category_id"])
        stores = @category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        @sub_category = SubCategory.find(params["sub_category_id"])
        stores = @sub_category.stores
      end
      stores.each do |store|
        branches << store.branches.where("address LIKE ? OR city LIKE ? OR state LIKE ? OR country LIKE ? OR zip LIKE ? ", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%")
      end
      search_into_everything(params, branches)
    elsif params["search"].present? || params["location"].present?
      stores = []
      Category.all.each do |category|
        stores << category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      end
      stores.flatten.each do |store|
        branches << store.branches.where("address LIKE ? OR city LIKE ? OR state LIKE ? OR country LIKE ? OR zip LIKE ? ", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%")
      end
      search_into_everything(params, branches)
    elsif params["store_id"].present?
      branches = Store.find(params["store_id"]).branches

      branches.each do |branch|
        if params["start_date"].present? && params["end_date"].present?
          @advertisements << branch.advertisements.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
          @deals << branch.deals.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
          @banners << branch.banners.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
        elsif params["start_date"].present?
          @advertisements << branch.advertisements.where("start_date >= ?", params[:start_date])
          @deals << branch.deals.where("start_date >= ?", params[:start_date])
          @banners << branch.banners.where("start_date >= ?", params[:start_date])
        elsif params["end_date"].present?
          @advertisements << branch.advertisements.where("end_date <= ?", params[:end_date])
          @deals << branch.deals.where("end_date <= ?", params[:end_date])
          @banners << branch.banners.where("end_date <= ?", params[:end_date])
        else
          @advertisements << branch.advertisements
          @deals << branch.deals
          @banners << branch.banners
        end
      end
    elsif params["start_date"].present? && params["end_date"].present?
      @advertisements = Advertisement.all.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
      @deals = Deal.all.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
      @banners = Banner.all.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
    elsif params["start_date"].present?
      @advertisements = Advertisement.all.where("start_date >= ?", params[:start_date])
      @deals = Deal.all.where("start_date >= ?", params[:start_date])
      @banners = Banner.all.where("start_date >= ?", params[:start_date])
    elsif params["end_date"].present?
      @advertisements = Advertisement.all.where("end_date <= ?", params[:end_date])
      @deals = Deal.all.where("end_date <= ?", params[:end_date])
      @banners = Banner.all.where("end_date <= ?", params[:end_date])
    else
      @advertisements = Advertisement.all
      @deals = Deal.all
      @banners = Banner.all
    end

    @advertisements = @advertisements.flatten.uniq
    @deals = @deals.flatten.uniq
    @banners = @banners.flatten.uniq

    if params["store_ids"].present?
      respond_to do |format|
        format.js
      end
    end
  end 
end
