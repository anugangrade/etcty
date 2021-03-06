class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.within_country(session[:country])
    @categories = @stores.all_sub_categories.group_by(&:category)

    if params["category_id"].present? || params["sub_category_id"].present?
      @stores = params["category_id"].present? ? Category.find(params["category_id"]).get_stores : SubCategory.find(params["sub_category_id"]).stores
    elsif params["store_id"].present? || (params[:location].present? && params[:location].values.reject(&:empty?).present?)
      store = Store.find(params["store_id"]) if params["store_id"].present?
      branches = store.present? ? (params[:location].values.reject(&:empty?).present? ? store.branches.where(country: session[:country]).in_location(params[:location]) : store.branches.where(country: session[:country], branchable_type: "Store")) : Branch.where(country: session[:country], branchable_type: "Store").in_location(params[:location])
      @stores = branches.collect(&:branchable)
    end
    @stores = @stores.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @categories =  @store.sub_categories.collect(&:category).uniq

    if params["branch_id"].present?
      branch = Branch.find(params["branch_id"])
      @advertisements = branch.advertisements.merge(BranchConnect.if_checked)
      @deals = branch.deals.merge(BranchConnect.if_checked)
      @sales = branch.sales.merge(BranchConnect.if_checked)
      @flyers = branch.flyers.merge(BranchConnect.if_checked)
      @video_advs = branch.video_advs.merge(BranchConnect.if_checked)
      @coupens = branch.coupens.merge(BranchConnect.if_checked)
    else
      @advertisements = @store.branches.collect{ |a| a.advertisements.merge(BranchConnect.if_checked)}.flatten.uniq
      @deals = @store.branches.collect{ |a| a.deals.merge(BranchConnect.if_checked)}.flatten.uniq
      @sales = @store.branches.collect{ |a| a.sales.merge(BranchConnect.if_checked)}.flatten.uniq
      @flyers = @store.branches.collect{ |a| a.flyers.merge(BranchConnect.if_checked)}.flatten.uniq
      @video_advs = @store.branches.collect{ |a| a.video_advs.merge(BranchConnect.if_checked)}.flatten.uniq
      @coupens = @store.branches.collect{ |a| a.coupens.merge(BranchConnect.if_checked)}.flatten.uniq
    end

    @hash = Gmaps4rails.build_markers(@store.branches) do |branch, marker|
      coordinates = Geocoder.coordinates(branch.zip)
      if coordinates.present?
        marker.lat coordinates[0]
        marker.lng coordinates[1]
        marker.title branch.name
      end
    end

  end

  # GET /stores/new
  def new
    @store = current_user.stores.build
    @store.branches.build
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = current_user.stores.new(store_params)

    respond_to do |format|
      if @store.save
        params["sub_categories_id"].split(",").each {|sub_category_id| @store.store_sub_categories.create(sub_category_id: sub_category_id)}
        format.html { redirect_to profile_path(locale: I18n.locale,username: @store.user.username), notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        if params["sub_categories_id"].present? 
          @not_required = @store.sub_categories.collect {|s| s.id.to_s} - params["sub_categories_id"].split(",")
          @not_required.each {|sub_category_id| @store.store_sub_categories.where(sub_category_id:  sub_category_id).destroy_all}
          params["sub_categories_id"].split(",").each {|sub_category_id| @store.store_sub_categories.create(sub_category_id: sub_category_id) if !@store.sub_categories.collect {|s| s.id.to_s}.include? sub_category_id}
        end
        format.html { redirect_to profile_path(locale: I18n.locale,username: @store.user.username), notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit!
    end
end
