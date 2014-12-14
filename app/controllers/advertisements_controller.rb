class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy, :complete_order]
  # GET /advertisements
  # GET /advertisements.json
  def index
    @advertisements = Advertisement.running(session[:country])
    @categories = @advertisements.all_sub_categories.group_by(&:category)
    
    if params["category_id"].present? || params["sub_category_id"].present?
      stores = params["category_id"].present? ? Category.find(params["category_id"]).get_stores : SubCategory.find(params["sub_category_id"]).stores
      @advertisements = stores.collect(&:branches).flatten.collect{ |b| b.advertisements.running(session[:country])}
    elsif params["store_id"].present? && params["zone_id"].present? 
      @advertisements = []
      store = Store.find(params["store_id"])
      zone = Zone.find(params["zone_id"])
      branches = (params["city"].present? || params["zip"].present?) ? store.branches.in_location(params) : store.branches
      
      branches.each do |branch|
        adv = branch.advertisements.merge(BranchConnect.if_checked).running(session[:country])

        adv.collect { |advertisement|
          @advertisements << advertisement if (advertisement.zones.merge(AdvZone.if_checked).include? zone)
        }
      end
    elsif params["store_id"].present?
      store = Store.find(params["store_id"])
      branches =  (params["city"].present? || params["zip"].present?) ? store.branches.in_location(params) : store.branches
      @advertisements = branches.collect{|b| b.advertisements.running(session[:country]) }
    elsif params["zone_id"].present?
      zone = Zone.find(params["zone_id"])
      all_advs = zone.advertisements.merge(AdvZone.if_checked).running(session[:country])
      if params["city"].present? || params["zip"].present?
        Branch.in_location(params).collect { |branch|
          @advertisements << all_advs if (all_advs.collect(&:branches).include? branch)
        }
      else
        @advertisements = all_advs
      end
    elsif params["city"].present? || params["zip"].present?
      @advertisements = Branch.in_location(params).collect{|b| b.advertisements.merge(BranchConnect.if_checked).running(session[:country]) }
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

    Zone.all.each do |zone|
      @advertisement.adv_zones.build(zone_id: zone.id)
    end
    current_user.stores.collect(&:branches).flatten.each do |branch|
      @advertisement.branch_connects.build(branch_id: branch.id)
    end
    redirect_to new_store_path(locale: I18n.locale), notice: "You first have to create a Store before creating advertisement" if current_user.stores.blank?
  end

  # GET /advertisements/1/edit
  def edit
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = current_user.advertisements.new(advertisement_params)
    @advertisement.save

    @advertisement.transactions.create(user_id: @advertisement.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_advertisement_path(@advertisement, locale: I18n.locale) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)
    redirect_to complete_order_advertisement_path(@advertisement, locale: I18n.locale)
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        format.html { redirect_to profile_path(locale: I18n.locale,username: @advertisement.user.username), notice: 'Advertisement was successfully updated.' }
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
      format.html { redirect_to profile_path(locale: I18n.locale,username: @advertisement.user.username), notice: 'Advertisement was successfully destroyed.' }
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
    redirect_to profile_path(locale: I18n.locale,username: @advertisement.user.username)
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
