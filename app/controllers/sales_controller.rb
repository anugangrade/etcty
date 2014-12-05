class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :complete_order]

  def index
    @sub_categories = Sale.all_sub_categories(session[:country])
    @categories = @sub_categories.collect(&:category).uniq

    params["sale_type"] = params["sale_type"].split(",") if params["sale_type"].present? && !params["sale_type"].kind_of?(Array) 

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @sales = stores.collect(&:branches).flatten.collect{ |b| b.sales.running(session[:country])}
    elsif params["store_id"].present?
      @sales = []

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

      branch_sales(branches)
    elsif params["city"].present? && params["zip"].present?
      @sales = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branch_sales(branches)
    elsif params["city"].present?
      @sales = []
      branches = Branch.where("city = ?", params["city"] )
      branch_sales(branches)
    elsif params["zip"].present?
      @sales = []
      branches = Branch.where("zip = ?", params["zip"] )
      branch_sales(branches)
    elsif params["sale_type"].present?
      @sales = []
      params["sale_type"].each do |sale_type|
        @sales << SaleType.find(sale_type).sales.running(session[:country])
      end
    else
      @sales = Sale.all.running(session[:country])
    end

    @sales = @sales.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  def new
    @sale = Sale.new
    SaleType.all.each do |a|
      @sale.sale_connects.build(sale_type_id: a.id)
    end
    current_user.stores.collect(&:branches).flatten.each do |branch|
      @sale.branch_connects.build(branch_id: branch.id)
    end
    redirect_to new_store_path(locale: I18n.locale), notice: "You first have to create a Store before creating banner" if current_user.stores.blank?
  end


  def create
    @sale = current_user.sales.create(sale_params)    
    @sale.transactions.create(user_id: @sale.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_sale_path(@sale, locale: I18n.locale) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)    
    redirect_to complete_order_sale_path(@sale, locale: I18n.locale)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to profile_path(locale: I18n.locale,username: @sale.user.username), notice: 'Advertisement was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(locale: I18n.locale,username: @sale.user.username), notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete_order
    # response = EXPRESS_GATEWAY.purchase((@sale.transactions[0].amount)*100, {:token => params[:token],:payer_id => params[:PayerID]})
    # @sale.transactions[0].update_attributes(paypal_token: params[:token], paypal_payer_id: params[:PayerID])
    @sale.transactions[0].update_attributes(status: "paid")

    # if response.success?
    #   @sale.transactions[0].update_attributes(status: "paid")
    # end
    # flash[:sucess] = response.success? ? "Congratulations, your sale has been created" : "Oops!! Problem with the payment completion. Please try again"
    redirect_to profile_path(locale: I18n.locale,username: @sale.user.username)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit!
    end

    def branch_sales(branches)
      branches.each do |branch|
        if params["sale_type"].present?
          params["sale_type"].each do |sale_type|
            if branch.sales.collect(&:sale_types).flatten.include? SaleType.find(sale_type)
              @sales << branch.sales.running(session[:country])
            end
          end
        else
          @sales << branch.sales.running(session[:country])
        end
      end
    end

end
