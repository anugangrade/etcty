class VideoAdvsController < ApplicationController
	before_action :set_video_adv, only: [:show, :edit, :update, :destroy, :complete_order]

  # GET /video_advs
  # GET /video_advs.json
  def index
    @sub_categories = VideoAdv.all_sub_categories(session[:country])
    @categories = @sub_categories.collect(&:category).uniq

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @video_advs = stores.collect(&:branches).flatten.collect{ |b| b.video_advs.running(session[:country])}
    elsif params["store_id"].present? || (params[:location].present? && params[:location].values.reject(&:empty?).present?)
      store = Store.find(params["store_id"]) if params["store_id"].present?

      branches = store.present? ? (params[:location].values.reject(&:empty?).present? ? store.branches.in_location(params[:location]) : store.branches) : Branch.in_location(params[:location])

      @video_advs = branches.collect{ |b| b.video_advs.running(session[:country])}
    else
      @video_advs = VideoAdv.running(session[:country])
    end

    @video_advs = @video_advs.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /video_advs/new
  def new
    @video_adv = VideoAdv.new
    current_user.stores.collect(&:branches).flatten.each do |branch|
      @video_adv.branch_connects.build(branch_id: branch.id)
    end
    redirect_to new_store_path(locale: I18n.locale), notice: "You first have to create a Store before creating video_adv" if current_user.stores.blank?
  end

  # POST /video_advs
  # POST /video_advs.json
  def create
    @video_adv = current_user.video_advs.create(video_adv_params)
    @video_adv.transactions.create(user_id: @video_adv.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_video_adv_path(@video_adv, locale: I18n.locale) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)

    redirect_to complete_order_video_adv_path(@video_adv, locale: I18n.locale)

  end

  def complete_order
    # response = EXPRESS_GATEWAY.purchase((@video_adv.transactions[0].amount)*100, {:token => params[:token],:payer_id => params[:PayerID]})
    # @video_adv.transactions[0].update_attributes(paypal_token: params[:token], paypal_payer_id: params[:PayerID])
    @video_adv.transactions[0].update_attributes(status: "paid")

    # if response.success?
    #   @video_adv.transactions[0].update_attributes(status: "paid")
    # end

    # flash[:sucess] = response.success? ? "Congratulations, your video_adv has been created" : "Oops!! Problem with the payment completion. Please try again"
    redirect_to profile_path(locale: I18n.locale,username: @video_adv.user.username)
  end


  def edit
  end

  # PATCH/PUT /video_advs/1
  # PATCH/PUT /video_advs/1.json
  def update
    respond_to do |format|
      if @video_adv.update(video_adv_params)
        format.html { redirect_to profile_path(locale: I18n.locale,username: @video_adv.user.username), notice: 'video_adv was successfully updated.' }
        format.json { render :show, status: :ok, location: @video_adv }
      else
        format.html { render :edit }
        format.json { render json: @video_adv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_advs/1
  # DELETE /video_advs/1.json
  def destroy
    @video_adv.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(locale: I18n.locale,username: @video_adv.user.username), notice: 'video_adv was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_adv
      @video_adv = VideoAdv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_adv_params
      params.require(:video_adv).permit!
    end
end
