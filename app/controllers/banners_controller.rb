class BannersController < ApplicationController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  # GET /banners
  # GET /banners.json
  def index
    @sub_categories = Banner.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq


    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @banners = stores.collect(&:branches).flatten.collect(&:banners)
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
      
      @banners = branches.collect{ |b| b.banners.running}
    elsif params["city"].present? && params["zip"].present?
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      @banners = branches.collect{ |b| b.banners.running}
    elsif params["city"].present?
      branches = Branch.where("city = ?", params["city"] )
      @banners = branches.collect{ |b| b.banners.running}
    elsif params["zip"].present?
      branches = Branch.where("zip = ?", params["zip"] )
      @banners = branches.collect{ |b| b.banners.running}
    else
      @banners = Banner.running
    end

    @banners = @banners.flatten.uniq
  end

  # GET /banners/1
  # GET /banners/1.json
  def show
  end

  # GET /banners/new
  def new
    @banner = Banner.new
    @stores = current_user.stores
    redirect_to new_store_path, notice: "You first have to create a Store before creating banner" if @stores.blank?
  end

  # GET /banners/1/edit
  def edit
  end

  # POST /banners
  # POST /banners.json
  def create
    @banner = current_user.banners.new(banner_params)

    respond_to do |format|
      if @banner.save
        params["branch"].each {|branch_id| @banner.banner_branches.create(branch_id: branch_id)}
        format.html { redirect_to profile_path(username: @banner.user.username), notice: 'Banner was successfully created.' }
        format.json { render :show, status: :created, location: @banner }
      else
        format.html { render :new }
        format.json { render json: @banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banners/1
  # PATCH/PUT /banners/1.json
  def update
    respond_to do |format|
      if @banner.update(banner_params)
        format.html { redirect_to profile_path(username: @banner.user.username), notice: 'Banner was successfully updated.' }
        format.json { render :show, status: :ok, location: @banner }
      else
        format.html { render :edit }
        format.json { render json: @banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banners/1
  # DELETE /banners/1.json
  def destroy
    @banner.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(username: @banner.user.username), notice: 'Banner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def banner_params
      params.require(:banner).permit(:title, :web_link, :image, :start_date, :end_date)
    end
end
