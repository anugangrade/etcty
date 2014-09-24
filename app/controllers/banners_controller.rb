class BannersController < ApplicationController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  # GET /banners
  # GET /banners.json
  def index
    @categories =  Banner.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.collect(&:category).uniq

    if params["category_id"].present? || params["sub_category_id"].present?
      @banners = []
      branches = []
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
      branches.flatten.each do |branch|
        @banners << branch.banners.where("title LIKE ?", "%#{params['search']}%")
      end
    elsif params["store_id"].present?
      @banners = []

      branches = Store.find(params["store_id"]).branches

      branches.each do |branch|
        if params["start_date"].present? && params["end_date"].present?
          @banners << branch.banners.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
        elsif params["start_date"].present?
          @banners << branch.banners.where("start_date >= ?", params[:start_date])
        elsif params["end_date"].present?
          @banners << branch.banners.where("end_date <= ?", params[:end_date])
        else
          @banners << branch.banners
        end
      end
    elsif params["start_date"].present? && params["end_date"].present?
      @banners = Banner.all.where("start_date >= ? AND end_date <= ?", params[:start_date], params[:end_date])
    elsif params["start_date"].present?
      @banners = Banner.all.where("start_date >= ?", params[:start_date])
    elsif params["end_date"].present?
      @banners = Banner.all.where("end_date <= ?", params[:end_date])
    else
      @banners = Banner.all
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
