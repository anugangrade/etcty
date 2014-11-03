class FlyersController < ApplicationController
	before_action :set_flyer, only: [:show, :edit, :update, :destroy, :complete_order]

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
      @flyers = stores.collect(&:branches).flatten.collect{ |b| b.flyers.running}
    elsif params["store_id"].present? || (params[:location].present? && params[:location].values.reject(&:empty?).present?)
      store = Store.find(params["store_id"]) if params["store_id"].present?

      branches = store.present? ? (params[:location].values.reject(&:empty?).present? ? store.branches.in_location(params[:location]) : store.branches) : Branch.in_location(params[:location])

      @flyers = branches.collect{ |b| b.flyers.running}
    else
      @flyers = Flyer.running
    end

    @flyers = @flyers.flatten.uniq.paginate(:page => params[:page], :per_page => 4)
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
    @flyer = current_user.flyers.create(flyer_params)

    params["branch"].each {|branch_id| @flyer.flyer_branches.create(branch_id: branch_id)}
    @flyer.transactions.create(user_id: @flyer.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_flyer_path(@flyer) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)
    redirect_to complete_order_flyer_path(@flyer)
  end

  def complete_order
    # response = EXPRESS_GATEWAY.purchase((@flyer.transactions[0].amount)*100, {:token => params[:token],:payer_id => params[:PayerID]})
    # @flyer.transactions[0].update_attributes(paypal_token: params[:token], paypal_payer_id: params[:PayerID])
    @flyer.transactions[0].update_attributes(status: "paid")

    # if response.success?
    #   @flyer.transactions[0].update_attributes(status: "paid")
    # end
    # flash[:sucess] = response.success? ? "Congratulations, your flyer has been created" : "Oops!! Problem with the payment completion. Please try again"
    redirect_to profile_path(username: @flyer.user.username)
  end

  def edit
    @stores = @flyer.user.stores
    @flyer_branches = @flyer.branches
  end

  # PATCH/PUT /flyers/1
  # PATCH/PUT /flyers/1.json
  def update
    respond_to do |format|
      if @flyer.update(flyer_params)

        @not_required = @flyer.branches.collect {|s| s.id.to_s} - params["branch"]
        @not_required.each {|branch_id| @flyer.flyer_branches.where(branch_id:  branch_id).destroy_all}
        params["branch"].each {|branch_id| @flyer.flyer_branches.create(branch_id: branch_id) if !@flyer.branches.collect {|s| s.id.to_s}.include? branch_id}
        

        
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
