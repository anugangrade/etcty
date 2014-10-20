class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy, :complete_order]

  # GET /advertisements
  # GET /advertisements.json
  def index
    @sub_categories = Advertisement.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq

    
    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @advertisements = stores.collect(&:branches).flatten.collect(&:advertisements)
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
    @advertisements = @advertisements.flatten.uniq.paginate(:page => params[:page], :per_page => 12)

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
    @zones = Zone.all.limit(9)
    @adv_zones = @advertisement.zones
    @stores = current_user.stores
    @adv_branches = @advertisement.branches
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = current_user.advertisements.new(advertisement_params)

    @zones = Zone.all.limit(9)
    @stores = current_user.stores

    @advertisement.save
    params["zone"].each {|zone_id| @advertisement.adv_zones.create(zone_id: zone_id)}
    params["branch"].each {|branch_id| @advertisement.adv_branches.create(branch_id: branch_id)}

    @advertisement.transactions.create(user_id: @advertisement.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_advertisement_path(@advertisement) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)
    redirect_to complete_order_advertisement_path(@advertisement)
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)

        @not_required = @advertisement.zones.collect {|s| s.id.to_s} - params["zone"]
        @not_required.each {|zone_id| @advertisement.adv_zones.where(zone_id:  zone_id).destroy_all}
        params["zone"].each {|zone_id| @advertisement.adv_zones.create(zone_id: zone_id) if !@advertisement.zones.collect {|s| s.id.to_s}.include? zone_id}
        
        @not_required = @advertisement.branches.collect {|s| s.id.to_s} - params["branch"]
        @not_required.each {|branch_id| @advertisement.adv_branches.where(branch_id:  branch_id).destroy_all}
        params["branch"].each {|branch_id| @advertisement.adv_branches.create(branch_id: branch_id) if !@advertisement.branches.collect {|s| s.id.to_s}.include? branch_id}
        
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

  def complete_order
    # response = EXPRESS_GATEWAY.purchase((@advertisement.transactions[0].amount)*100, {:token => params[:token],:payer_id => params[:PayerID]})
    # @advertisement.transactions[0].update_attributes(paypal_token: params[:token], paypal_payer_id: params[:PayerID])
    @advertisement.transactions[0].update_attributes(status: "paid")

    # if response.success?
    #   @advertisement.transactions[0].update_attributes(status: "paid")
    # end
    # flash[:sucess] = response.success? ? "Congratulations, your advertisement has been created" : "Oops!! Problem with the payment completion. Please try again"
    redirect_to profile_path(username: @advertisement.user.username)
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
