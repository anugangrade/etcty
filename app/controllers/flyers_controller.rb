class FlyersController < InheritedResources::Base
	before_action :set_flyer, only: [:show, :edit, :update, :destroy]

  # GET /flyers
  # GET /flyers.json
  def index
    @sub_categories = Flyer.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq


    if params["category_id"].present? || params["sub_category_id"].present?
      @flyers = []
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
        @flyers << branch.flyers.where("title LIKE ?", "%#{params['search']}%")
      end
    elsif params["store_id"].present?
      @flyers = []
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
        @flyers << branch.flyers
      end
    elsif params["city"].present? && params["zip"].present?
      @flyers = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        @flyers << branch.flyers
      end
    elsif params["city"].present?
      @flyers = []
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        @flyers << branch.flyers
      end
    elsif params["zip"].present?
      @flyers = []
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        @flyers << branch.flyers
      end
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
