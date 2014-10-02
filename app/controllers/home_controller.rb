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
    @sub_categories = Advertisement.all_sub_categories
    @sub_categories << Deal.all_sub_categories
    @sub_categories << Banner.all_sub_categories
    @sub_categories << Sale.all_sub_categories
    @sub_categories << Education.all_sub_categories
    @sub_categories << Flyer.all_sub_categories
    
    @categories = @sub_categories.flatten.collect(&:category).flatten.uniq



    @advertisements = []
    @deals = []
    @banners = []
    @sales = []
    @educations = []
    @flyers = []
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
      if params["location"].present?
        Store.all.each do |store|
          branches << store.branches.where("address LIKE ? OR city LIKE ? OR state LIKE ? OR country LIKE ? OR zip LIKE ? ", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%", "%#{params['location']}%")
        end
      else
        branches = Branch.all
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

      @advertisements = branches.collect(&:advertisements)
      @deals = branches.collect(&:deals)
      @banners = branches.collect(&:banners)

      @sales = branches.collect(&:sales)
      @educations = branches.collect(&:educations)
      @flyers = branches.collect(&:flyers)

    elsif params["city"].present? && params["zip"].present?
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )

      @advertisements = branches.collect(&:advertisements)
      @deals = branches.collect(&:deals)
      @banners = branches.collect(&:banners)

      @sales = branches.collect(&:sales)
      @educations = branches.collect(&:educations)
      @flyers = branches.collect(&:flyers)

    elsif params["city"].present?
      branches = Branch.where("city = ?", params["city"] )
      @advertisements = branches.collect(&:advertisements)
      @deals = branches.collect(&:deals)
      @banners = branches.collect(&:banners)

      @sales = branches.collect(&:sales)
      @educations = branches.collect(&:educations)
      @flyers = branches.collect(&:flyers)

    elsif params["zip"].present?
      branches = Branch.where("zip = ?", params["zip"] )
      @advertisements = branches.collect(&:advertisements)
      @deals = branches.collect(&:deals)
      @banners = branches.collect(&:banners)

      @sales = branches.collect(&:sales)
      @educations = branches.collect(&:educations)
      @flyers = branches.collect(&:flyers)

    else
      @advertisements = Advertisement.all
      @deals = Deal.all
      @banners = Banner.all

      @sales = Sale.all
      @educations = Education.all
      @flyers = Flyer.all
    end

    @advertisements = @advertisements.flatten.uniq
    @deals = @deals.flatten.uniq
    @banners = @banners.flatten.uniq
    @sales = @sales.flatten.uniq
    @educations = @educations.flatten.uniq
    @flyers = @flyers.flatten.uniq

  end 
end
