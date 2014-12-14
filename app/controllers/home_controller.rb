class HomeController < ApplicationController

  include HomeHelper
  def index
    if !session[:country].present?
      @location = GeoIP.new('GeoIP.dat').country(request.ip)
      #<struct GeoIP::Country request="117.212.247.251", ip="117.212.247.251", country_code=103, country_code2="IN", country_code3="IND", country_name="India", continent_code="AS">
      session[:country] = @location.country_code2
    end

    if !session[:category_header].present?
      session[:category_header] = Category.order("name").collect{|c| [c.id, c.name] }
    end

  	advertisements = Advertisement.running(session[:country]).flatten.uniq
    @zones_having_data = advertisements.collect{ |a| a.zones.merge(AdvZone.if_checked) }.flatten.uniq.sort_by(&:name)

    split_count = (advertisements.size/3) + 1
    @advertisements = advertisements.each_slice(split_count).to_a


    @deal_types = DealType.limit(4)
    @sale_types = SaleType.limit(2)
    @coupen_types = CoupenType.limit(2)
  	@education_types = EducationType.limit(2)
    @top_banners = Banner.running.where(position: "Top")
    @bottom_banners = Banner.running.where(position: "Bottom")
    @flyers = Flyer.running(session[:country])
    @tutorials = Tutorial.running(session[:country])
    @videos = VideoAdv.running(session[:country])
  end

  def profile
  	@user = User.find_by_username(params[:username])
  	@stores = @user.is_admin ? Store.all : @user.stores
  	@advertisements = @user.is_admin ? Advertisement.all : @user.advertisements
    @deals = @user.is_admin ? Deal.all : @user.deals
    @sales = @user.is_admin ? Sale.all : @user.sales
    @educations = @user.is_admin ? Education.all : @user.educations
    @flyers = @user.is_admin ? Flyer.all : @user.flyers
    @video_advs = @user.is_admin ? VideoAdv.all : @user.video_advs
    @coupens = @user.is_admin ? Coupen.all : @user.coupens
    @institutes = @user.is_admin ? Institute.all : @user.institutes
  	@tutorials = @user.is_admin ? Tutorial.all : @user.tutorials
    @banners = Banner.all if @user.is_admin
  end

  def category_sub
    @sub_categories = SubCategory.where("lower(name) like ?", "%#{params[:q].downcase}%")
    @categories = Category.where("lower(name) like ?", "%#{params[:q].downcase}%")
    @categories.each do |category|
      @sub_categories << category.sub_categories
    end
    render :json => @sub_categories.flatten.uniq.map {|f| {:id=> f.id, :name=> "#{f.name}-#{f.category.name}"} }
  end

  def get_store
    store = Store.where("lower(name) like ?", "%#{params[:q].downcase}%")
    render :json => store
  end

  def get_institute
    institute = Institute.where("lower(name) like ?", "%#{params[:q].downcase}%")
    render :json => institute
  end

  def get_city
    city = Branch.where("lower(city) like ?", "%#{params[:q].downcase}%").map {|f| {:id=> f.city, :name=> f.city} }
    render :json => city
  end

  def get_zip
    zip = Branch.where("lower(zip) like ?", "%#{params[:q].downcase}%").map {|f| {:id=> f.zip, :name=> f.zip} }
    render :json => zip
  end

  def get_zone
    zone = Zone.where("lower(name) like ?", "%#{params[:q].downcase}%")
    render :json => zone
  end

  def search_result
    @sub_categories = Advertisement.all_sub_categories(session[:country])
    @sub_categories << Deal.all_sub_categories(session[:country])
    @sub_categories << Sale.all_sub_categories(session[:country])
    @sub_categories << Education.all_sub_categories(session[:country])
    @sub_categories << Flyer.all_sub_categories(session[:country])
    @sub_categories << VideoAdv.all_sub_categories(session[:country])
    @sub_categories << Coupen.all_sub_categories(session[:country])
    
    @categories = @sub_categories.flatten.collect(&:category).flatten.uniq

    @advertisements = []
    @deals = []
    @sales = []
    @educations = []
    @flyers = []
    @video_advs = []
    @coupens = []
    @tutorials = []
    branches = []

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        @category = Category.find(params["category_id"])
        stores = @category.get_stores
        institutes = @category.get_institutes
      else
        @sub_category = SubCategory.find(params["sub_category_id"])
        stores = @sub_category.stores
        institutes = @sub_category.institutes
      end
      stores.each{ |i| branches << search_into_branches(i, params) }
      institutes.each{ |i| branches << search_into_branches(i, params) }

      search_into_everything(params, branches)
    elsif params["search"].present? || params["location"].present?
      if params["location"].present?
        Store.all.each{ |i| branches << search_into_branches(i, params) }
        Institute.all.each{ |i| branches << search_into_branches(i, params) }
      else
        branches = Branch.all
      end
      search_into_everything(params, branches)

    elsif params["store_id"].present?
      store = Store.find(params["store_id"])
      branches = (params["city"].present? || params["zip"].present?) ? store.branches.in_location(params) : store.branches

      all_branch_related(branches)

    elsif params["city"].present? || params["zip"].present?
      branches = Branch.in_location(params)

      all_branch_related(branches)

    elsif params["city"].present?
      branches = Branch.where("city = ?", params["city"] )
      all_branch_related(branches)

    elsif params["zip"].present?
      branches = Branch.where("zip = ?", params["zip"] )
      all_branch_related(branches)

    else
      @advertisements = Advertisement.all
      @deals = Deal.all
      @sales = Sale.all
      @educations = Education.all
      @flyers = Flyer.all
      @video_advs = VideoAdv.all
      @coupens = Coupen.all
      @tutorials = Tutorial.all
    end

    @advertisements = @advertisements.flatten.uniq
    @deals = @deals.flatten.uniq
    @sales = @sales.flatten.uniq
    @educations = @educations.flatten.uniq
    @flyers = @flyers.flatten.uniq
    @video_advs = @video_advs.flatten.uniq
    @coupens = @coupens.flatten.uniq
    @tutorials = @tutorials.flatten.uniq

  end


  def users
    @users = User.where("id != ?", current_user.id)
  end

  def block_user
    user = User.find(params[:id])
    user.update_attributes(block: (user.block ? false : true))
    redirect_to users_path(locale: I18n.locale)
  end

  def change_session_country
    session[:country] = params[:country_code]
    render json: {url: request.referer }
  end

  def all_branch_related(branches)
    @advertisements = branches.collect(&:advertisements).merge(BranchConnect.if_checked)
    @deals = branches.collect(&:deals).merge(BranchConnect.if_checked)
    @sales = branches.collect(&:sales).merge(BranchConnect.if_checked)
    @educations = branches.collect(&:educations).merge(BranchConnect.if_checked)
    @flyers = branches.collect(&:flyers).merge(BranchConnect.if_checked)
    @video_advs = branches.collect(&:video_advs).merge(BranchConnect.if_checked)
    @coupens = branches.collect(&:coupens).merge(BranchConnect.if_checked)
    @tutorials = branches.collect(&:tutorials).merge(BranchConnect.if_checked)
  end

  def search_into_branches(model, params)
    model.branches.where("lower(address) LIKE ? OR lower(city) LIKE ? OR lower(state) LIKE ? OR lower(country) LIKE ? OR zip LIKE ? ", "%#{params['location'].downcase}%", "%#{params['location'].downcase}%", "%#{params['location'].downcase}%", "%#{params['location'].downcase}%", "%#{params['location'].downcase}%")
  end
end
