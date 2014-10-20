class SalesController < InheritedResources::Base
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :complete_order]

  def index
    @sub_categories = Sale.all_sub_categories
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
      @sales = stores.collect(&:branches).flatten.collect(&:sales)
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

      branches.each do |branch|
        if params["sale_type"].present?
          params["sale_type"].each do |sale_type|
            if branch.sales.collect(&:sale_types).flatten.include? SaleType.find(sale_type)
              @sales << branch.sales
            end
          end
        else
          @sales << branch.sales
        end
      end
    elsif params["city"].present? && params["zip"].present?
      @sales = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        if params["sale_type"].present?
          params["sale_type"].each do |sale_type|
            if branch.sales.collect(&:sale_types).flatten.include? SaleType.find(sale_type)
              @sales << branch.sales
            end
          end
        else
          @sales << branch.sales
        end
      end
    elsif params["city"].present?
      @sales = []
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        if params["sale_type"].present?
          params["sale_type"].each do |sale_type|
            if branch.sales.collect(&:sale_types).flatten.include? SaleType.find(sale_type)
              @sales << branch.sales
            end
          end
        else
          @sales << branch.sales
        end
      end
    elsif params["zip"].present?
      @sales = []
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        if params["sale_type"].present?
          params["sale_type"].each do |sale_type|
            if branch.sales.collect(&:sale_types).flatten.include? SaleType.find(sale_type)
              @sales << branch.sales
            end
          end
        else
          @sales << branch.sales
        end
      end
    elsif params["sale_type"].present?
      @sales = []
      params["sale_type"].each do |sale_type|
        @sales << SaleType.find(sale_type).sales
      end
    else
      @sales = Sale.all
    end

    @sales = @sales.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  def new
    @sale = Sale.new
    @stores = current_user.stores
    @sale_types = SaleType.all.limit(2)
    redirect_to new_store_path, notice: "You first have to create a Store before creating banner" if @stores.blank?
  end


  def create
    @sale = current_user.sales.new(sale_params)

    @sale.save
    params["sale_type"].each {|sale_type_id| @sale.sale_connects.create(sale_type_id: sale_type_id)}
    params["branch"].each {|branch_id| @sale.sale_branches.create(branch_id: branch_id)}
    
    @sale.transactions.create(user_id: @sale.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_sale_path(@sale) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)    
    redirect_to complete_order_sale_path(@sale)
  end

  def edit
    @sale_types = SaleType.all.limit(4)
    @stores = current_user.stores

    @sale_sale_types = @sale.sale_types
    @sale_branches = @sale.branches
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)

        @not_required = @sale.sale_types.collect {|s| s.id.to_s} - params["sale_type"]
        @not_required.each {|sale_type_id| @sale.sale_connects.where(sale_type_id:  sale_type_id).destroy_all}
        params["sale_type"].each {|sale_type_id| @sale.sale_connects.create(sale_type_id: sale_type_id) if !@sale.sale_types.collect {|s| s.id.to_s}.include? sale_type_id}
        
        @not_required = @sale.branches.collect {|s| s.id.to_s} - params["branch"]
        @not_required.each {|branch_id| @sale.sale_branches.where(branch_id:  branch_id).destroy_all}
        params["branch"].each {|branch_id| @sale.sale_branches.create(branch_id: branch_id) if !@sale.branches.collect {|s| s.id.to_s}.include? branch_id}
        
        
        format.html { redirect_to profile_path(username: @sale.user.username), notice: 'Advertisement was successfully updated.' }
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
      format.html { redirect_to profile_path(username: @sale.user.username), notice: 'Sale was successfully destroyed.' }
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
    redirect_to profile_path(username: @sale.user.username)
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

end
