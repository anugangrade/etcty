class HomeController < ApplicationController
  include HomeHelper
  def index
  	@zones = Zone.all.limit(9)
    @deal_types = DealType.all.limit(4)
    @sale_types = SaleType.all.limit(2)
  	@education_types = EducationType.all.limit(2)
    @banners = Banner.all.order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
    @flyers = Flyer.all.order(ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2" ? "RAND()" : "RANDOM()")
  end

  def profile
  	@user = User.find_by_username(params[:username])
  	@stores = @user.stores
  	@advertisements = @user.advertisements
    @deals = @user.deals
    @banners = @user.banners
    @sales = @user.sales
    @educations = @user.educations
  	@flyers = @user.flyers
  end

  def category_sub
    @sub_categories = SubCategory.where("name like ?", "%#{params[:q]}%")
    @categories = Category.where("name like ?", "%#{params[:q]}%")
    @categories.each do |category|
      @sub_categories << category.sub_categories
    end
    render :json => @sub_categories.flatten.uniq.map {|f| {:id=> f.id, :name=> "#{f.name}-#{f.category.name}"} }
  end

  def get_store
    store = Store.where("name like ?", "%#{params[:q]}%")
    render :json => store
  end

  def get_city
    city = Branch.where("city like ?", "%#{params[:q]}%").map {|f| {:id=> f.city, :name=> f.city} }
    render :json => city
  end

  def get_zip
    zip = Branch.where("zip like ?", "%#{params[:q]}%").map {|f| {:id=> f.zip, :name=> f.zip} }
    render :json => zip
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
      store = Store.find(params["store_id"])
      if params["city"].present? && params["zip"].present?
        branches = store.branches.where("city = ? AND zip = ?", params["city"], params["zip"] )
      elsif params["city"].present?
        branches = store.branches.where("city = ?", params["city"] )
      elsif params["zip"].present?
        branches = store.branches.where("zip = ?", params["zip"] )
      else
        branches = store.branches
      end

      branches.each do |branch|
        @advertisements << branch.advertisements
        @deals << branch.deals
        @banners << branch.banners
      end
    elsif params["city"].present? && params["zip"].present?
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        @advertisements << branch.advertisements
        @deals << branch.deals
        @banners << branch.banners
      end
    elsif params["city"].present?
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        @advertisements << branch.advertisements
        @deals << branch.deals
        @banners << branch.banners
      end
    elsif params["zip"].present?
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        @advertisements << branch.advertisements
        @deals << branch.deals
        @banners << branch.banners
      end
    else
      @advertisements = Advertisement.all
      @deals = Deal.all
      @banners = Banner.all
    end

    @advertisements = @advertisements.flatten.uniq
    @deals = @deals.flatten.uniq
    @banners = @banners.flatten.uniq

  end 
end
