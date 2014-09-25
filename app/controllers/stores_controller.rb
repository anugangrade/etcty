class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores
  # GET /stores.json
  def index
    @categories =  Store.all.collect(&:sub_categories).flatten.collect(&:category).uniq

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        @category = Category.find(params["category_id"])
        @stores = @category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        @sub_category = SubCategory.find(params["sub_category_id"])
        @stores = @sub_category.stores
      end
    elsif params["store_id"].present?
      @stores = Store.where(id: params["store_id"])
    elsif params["city"].present? && params["zip"].present?
      @stores = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        @stores << branch.store
      end
    elsif params["city"].present?
      @stores = []
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        @stores << branch.store
      end
    elsif params["zip"].present?
      @stores = []
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        @stores << branch.store
      end
    else
      @stores = Store.all
    end

    @stores = @stores.flatten.uniq

  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @categories =  @store.sub_categories.collect(&:category).uniq

    if params["branch_id"].present?
      branch = Branch.find(params["branch_id"])
      @advertisements = branch.advertisements
      @deals = branch.deals
      @banners = branch.banners
    else
      @advertisements = []
      @deals = []
      @banners = []
      @store.branches.each do |branch|
        @advertisements << branch.advertisements
        @deals << branch.deals
        @banners << branch.banners
      end
    end

    @advertisements = @advertisements.flatten.uniq
    @deals = @deals.flatten.uniq
    @banners = @banners.flatten.uniq

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
        format.html { redirect_to profile_path(username: @store.user.username), notice: 'Store was successfully created.' }
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
        @not_required = @store.sub_categories.collect {|s| s.id.to_s} - params["sub_categories_id"].split(",")
        @not_required.each {|sub_category_id| @store.store_sub_categories.where(sub_category_id:  sub_category_id).destroy_all}

        params["sub_categories_id"].split(",").each {|sub_category_id| @store.store_sub_categories.create(sub_category_id: sub_category_id) if !@store.sub_categories.collect {|s| s.id.to_s}.include? sub_category_id}
        
        format.html { redirect_to profile_path(username: @store.user.username), notice: 'Store was successfully updated.' }
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
