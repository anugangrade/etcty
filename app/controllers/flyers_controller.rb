class FlyersController < InheritedResources::Base
	before_action :set_flyer, only: [:show, :edit, :update, :destroy]

  # GET /flyers
  # GET /flyers.json
  def index
    @sub_categories = Flyer.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @flyers = stores.collect(&:branches).flatten.collect(&:flyers)
    elsif params["store_id"].present? || (params[:location].present? && params[:location].values.reject(&:empty?).present?)
      store = Store.find(params["store_id"]) if params["store_id"].present?

      branches = store.present? ? (params[:location].values.reject(&:empty?).present? ? store.branches.in_location(params[:location]) : store.branches) : Branch.in_location(params[:location])

      @flyers = branches.collect(&:flyers)
    else
      @flyers = Flyer.all
    end

    @flyers = @flyers.flatten.uniq
  end

  # GET /flyers/new
  def new
    @flyer = Flyer.new
    @stores = current_user.stores
    redirect_to new_store_path, notice: "You first have to create a Store before creating flyer" if @stores.blank?
  end

  # POST /flyers
  # POST /flyers.json
  def create
    @flyer = current_user.flyers.new(flyer_params)

    respond_to do |format|
      if @flyer.save
        params["branch"].each {|branch_id| @flyer.flyer_branches.create(branch_id: branch_id)}
        format.html { redirect_to profile_path(username: @flyer.user.username), notice: 'flyer was successfully created.' }
        format.json { render :show, status: :created, location: @flyer }
      else
        format.html { render :new }
        format.json { render json: @flyer.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @stores = current_user.stores
  end

  # PATCH/PUT /flyers/1
  # PATCH/PUT /flyers/1.json
  def update
    respond_to do |format|
      if @flyer.update(flyer_params)
        format.html { redirect_to profile_path(username: @flyer.user.username), notice: 'flyer was successfully updated.' }
        format.json { render :show, status: :ok, location: @flyer }
      else
        format.html { render :edit }
        format.json { render json: @flyer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flyers/1
  # DELETE /flyers/1.json
  def destroy
    @flyer.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(username: @flyer.user.username), notice: 'flyer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flyer
      @flyer = Flyer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flyer_params
      params.require(:flyer).permit!
    end
end
