class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy, :complete_order]

  # GET /deals
  # GET /deals.json
  def index
    @sub_categories = Deal.all_sub_categories(session[:country])
    @categories = @sub_categories.collect(&:category).uniq

    params["deal_type"] = params["deal_type"].split(",") if params["deal_type"].present? && !params["deal_type"].kind_of?(Array) 

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @deals = stores.collect(&:branches).flatten.collect.collect{ |b| b.deals.running(session[:country])}

    elsif params["store_id"].present?
      @deals = []

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

      branch_deals(branches)
    elsif params["city"].present? && params["zip"].present?
      @deals = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branch_deals(branches)
    elsif params["city"].present?
      @deals = []
      branches = Branch.where("city = ?", params["city"] )
      branch_deals(branches)
    elsif params["zip"].present?
      @deals = []
      branches = Branch.where("zip = ?", params["zip"] )
      branch_deals(branches)
    elsif params["deal_type"].present?
      @deals = []
      params["deal_type"].each do |deal_type|
        @deals << DealType.find(deal_type).deals.running(session[:country])
      end
    else
      @deals = Deal.all.running(session[:country])
    end

    @deals = @deals.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
  end

  # GET /deals/new
  def new
    @deal = Deal.new
    DealType.all.each do |a|
      @deal.deal_connects.build(deal_type_id: a.id)
    end
    current_user.stores.collect(&:branches).flatten.each do |branch|
      @deal.branch_connects.build(branch_id: branch.id)
    end

    redirect_to new_store_path(locale: I18n.locale), notice: "You first have to create a Store before creating deal" if current_user.stores.blank?
  end

  # GET /deals/1/edit
  def edit
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = current_user.deals.create(deal_params)
    
    @deal.transactions.create(user_id: @deal.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_deal_path(@deal, locale: I18n.locale) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)
    redirect_to complete_order_deal_path(@deal, locale: I18n.locale)
  end

  # PATCH/PUT /deals/1
  # PATCH/PUT /deals/1.json
  def update
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to profile_path(locale: I18n.locale,username: @deal.user.username), notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  # DELETE /deals/1.json
  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(locale: I18n.locale,username: @deal.user.username), notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete_order
    # response = EXPRESS_GATEWAY.purchase((@deal.transactions[0].amount)*100, {:token => params[:token],:payer_id => params[:PayerID]})
    # @deal.transactions[0].update_attributes(paypal_token: params[:token], paypal_payer_id: params[:PayerID])
    @deal.transactions[0].update_attributes(status: "paid")

    # if response.success?
    #   @deal.transactions[0].update_attributes(status: "paid")
    # end
    # flash[:sucess] = response.success? ? "Congratulations, your deal has been created" : "Oops!! Problem with the payment completion. Please try again"
    redirect_to profile_path(locale: I18n.locale,username: @deal.user.username)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal
      @deal = Deal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_params
      params.require(:deal).permit!
    end

    def branch_deals(branches)
      branches.each do |branch|
        if params["deal_type"].present?
          params["deal_type"].each do |deal_type|
            if branch.deals.collect(&:deal_types).flatten.include? DealType.find(deal_type)
              @deals << branch.deals.running(session[:country])
            end
          end
        else
          @deals << branch.deals.running(session[:country])
        end
      end
    end
end
