class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores
  # GET /stores.json
  def index
    @sub_categories = Store.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq


    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        @category = Category.find(params["category_id"])
        @stores = @category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        @sub_category = SubCategory.find(params["sub_category_id"])
        @stores = @sub_category.stores
      end
    elsif params["store_id"].present? || (params[:location].present? && params[:location].values.reject(&:empty?).present?)
      store = Store.find(params["store_id"]) if params["store_id"].present?
      branches = store.present? ? (params[:location].values.reject(&:empty?).present? ? store.branches.in_location(params[:location]) : store.branches) : Branch.in_location(params[:location])
      @stores = branches.collect(&:store)
    else
      @stores = Store.all
    end
    @stores = @stores.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @categories =  @store.sub_categories.collect(&:category).uniq

    if params["branch_id"].present?
      branch = Branch.find(params["branch_id"])
      @advertisements = branch.advertisements
      @deals = branch.deals
      @sales = branch.sales
    else
      @advertisements = @store.branches.collect(&:advertisements).flatten.uniq
      @deals = @store.branches.collect(&:deals).flatten.uniq
      @sales = @store.branches.collect(&:sales).flatten.uniq
      @educations = @store.branches.collect(&:educations).flatten.uniq
      @flyers = @store.branches.collect(&:flyers).flatten.uniq
      @video_advs = @store.branches.collect(&:video_advs).flatten.uniq
      @coupens = @store.branches.collect(&:coupens).flatten.uniq
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
