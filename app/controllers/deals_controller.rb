class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  # GET /deals
  # GET /deals.json
  def index
    @categories =  Deal.all.collect(&:branches).flatten.collect(&:store).collect(&:sub_categories).flatten.collect(&:category).uniq

    if params["category_id"].present? || params["sub_category_id"].present?
      @deals = []
      branches = []
      if params["category_id"].present?
        @category = Category.find(params["category_id"])
        stores = @category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        @sub_category = SubCategory.find(params["sub_category_id"])
        stores = @sub_category.stores
      end
      stores.each do |store|
        branches << store.branches
      end
      branches.flatten.each do |branch|
        @deals << branch.deals
      end
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

      branches.each do |branch|
        @deals << branch.deals
      end
    elsif params["city"].present? && params["zip"].present?
      @deals = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        @deals << branch.deals
      end
    elsif params["city"].present?
      @deals = []
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        @deals << branch.deals
      end
    elsif params["zip"].present?
      @deals = []
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        @deals << branch.deals
      end
    else
      @deals = Deal.all
    end

    @deals = @deals.flatten.uniq
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
  end

  # GET /deals/new
  def new
    @deal = Deal.new
    @deal_types = DealType.all.limit(4)
    @stores = current_user.stores

    redirect_to new_store_path, notice: "You first have to create a Store before creating deal" if @stores.blank?
  end

  # GET /deals/1/edit
  def edit
    @deal_types = DealType.all.limit(4)
    @stores = current_user.stores
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = current_user.deals.new(deal_params)

    respond_to do |format|
      if @deal.save
        params["deal_type"].each {|deal_type_id| @deal.deal_connects.create(deal_type_id: deal_type_id)}
        params["branch"].each {|branch_id| @deal.deal_branches.create(branch_id: branch_id)}
        
        format.html { redirect_to profile_path(username: @deal.user.username), notice: 'Deal was successfully created.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deals/1
  # PATCH/PUT /deals/1.json
  def update
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to profile_path(username: @deal.user.username), notice: 'Deal was successfully updated.' }
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
      format.html { redirect_to profile_path(username: @deal.user.username), notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
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
end
