class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]

  # GET /advertisements
  # GET /advertisements.json
  def index
    @categories = Advertisement.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.collect(&:category).uniq
    
    if params["category_id"].present? || params["sub_category_id"].present?
      @advertisements = []
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
        @advertisements << branch.advertisements.where("title LIKE ?", "%#{params['search']}%")
      end
    elsif params["store_id"].present? && params["zone_id"].present?
      @advertisements = []

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
        adv = branch.advertisements

        adv.each do |advertisement|
          if advertisement.zones.include? Zone.find(params["zone_id"])
            @advertisements << advertisement
          end
        end
      end
    elsif params["store_id"].present?
      @advertisements = []

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
      end
    elsif params["zone_id"].present?
      zone = Zone.find(params["zone_id"])
      if params["city"].present? && params["zip"].present?
        branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      elsif params["city"].present?
        branches = Branch.where("city = ?", params["city"] )
      elsif params["zip"].present?
        branches = Branch.where("zip = ?", params["zip"] )
      else
        @advertisements = zone.advertisements
      end

      if branches
        @advertisements = []
        branches.each do |branch|
          @advertisements << zone.advertisements if zone.advertisements.collect(&:branches).include? branch
        end
      end

    elsif params["city"].present? && params["zip"].present?
      @advertisements = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        @advertisements << branch.advertisements
      end
    elsif params["city"].present?
      @advertisements = []
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        @advertisements << branch.advertisements
      end
    elsif params["zip"].present?
      @advertisements = []
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        @advertisements << branch.advertisements
      end
    else    
      @advertisements = Advertisement.all
    end

    @advertisements = @advertisements.flatten.uniq
  end

  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
  end

  # GET /advertisements/new
  def new
    @advertisement = Advertisement.new
    @zones = Zone.all.limit(9)
    @stores = current_user.stores
    redirect_to new_store_path, notice: "You first have to create a Store before creating advertisement" if @stores.blank?
  end

  # GET /advertisements/1/edit
  def edit
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = current_user.advertisements.new(advertisement_params)

    @zones = Zone.all.limit(9)
    @stores = current_user.stores

    respond_to do |format|
      if @advertisement.save
        params["zone"].each {|zone_id| @advertisement.adv_zones.create(zone_id: zone_id)}
        params["branch"].each {|branch_id| @advertisement.adv_branches.create(branch_id: branch_id)}

        format.html { redirect_to profile_path(username: @advertisement.user.username), notice: 'Advertisement was successfully created.' }
        format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        format.html { redirect_to profile_path(username: @advertisement.user.username), notice: 'Advertisement was successfully updated.' }
        format.json { render :show, status: :ok, location: @advertisement }
      else
        format.html { render :edit }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisements/1
  # DELETE /advertisements/1.json
  def destroy
    @advertisement.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(username: @advertisement.user.username), notice: 'Advertisement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertisement
      @advertisement = Advertisement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advertisement_params
      params.require(:advertisement).permit!
    end
end
