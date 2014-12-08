class CoupensController < ApplicationController
	before_action :set_coupen, only: [:show, :edit, :update, :destroy]

  # GET /coupens
  # GET /coupens.json
  def index
    @sub_categories = Coupen.all_sub_categories(session[:country])
    @categories = @sub_categories.collect(&:category).uniq

    params["coupen_type"] = params["coupen_type"].split(",") if params["coupen_type"].present? && !params["coupen_type"].kind_of?(Array) 

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @coupens = stores.collect(&:branches).flatten.collect{ |b| b.coupens.running(session[:country])}
    elsif params["store_id"].present?
      @coupens = []

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

      branch_coupens(branches)
    elsif params["city"].present? && params["zip"].present?
      @coupens = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branch_coupens(branches)
    elsif params["city"].present?
      @coupens = []
      branches = Branch.where("city = ?", params["city"] )
      branch_coupens(branches)
    elsif params["zip"].present?
      @coupens = []
      branches = Branch.where("zip = ?", params["zip"] )
      branch_coupens(branches)
    elsif params["coupen_type"].present?
      @coupens = []
      params["coupen_type"].each do |coupen_type|
        @coupens << CoupenType.find(coupen_type).coupens.running(session[:country])
      end
    else
      @coupens = Coupen.all.running(session[:country])
    end

    @coupens = @coupens.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /coupens/1
  # GET /coupens/1.json
  def show
  end

  # GET /coupens/new
  def new
    @coupen = Coupen.new
    CoupenType.all.each do |a|
      @coupen.coupen_connects.build(coupen_type_id: a.id)
    end
    current_user.stores.collect(&:branches).flatten.each do |branch|
      @coupen.branch_connects.build(branch_id: branch.id)
    end

    redirect_to new_store_path(locale: I18n.locale), notice: "You first have to create a Store before creating Coupen" if current_user.stores.blank?
  end

  # GET /coupens/1/edit
  def edit
  end

  # POST /coupens
  # POST /coupens.json
  def create
    @coupen = current_user.coupens.new(coupen_params)

    respond_to do |format|
      if @coupen.save  
        format.html { redirect_to profile_path(locale: I18n.locale,username: @coupen.user.username), notice: 'Coupen was successfully created.' }
        format.json { render :show, status: :created, location: @coupen }
      else
        format.html { render :new }
        format.json { render json: @coupen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coupens/1
  # PATCH/PUT /coupens/1.json
  def update
    respond_to do |format|
      if @coupen.update(coupen_params)
        format.html { redirect_to profile_path(locale: I18n.locale,username: @coupen.user.username), notice: 'Coupen was successfully updated.' }
        format.json { render :show, status: :ok, location: @coupen }
      else
        format.html { render :edit }
        format.json { render json: @coupen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupens/1
  # DELETE /coupens/1.json
  def destroy
    @coupen.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(locale: I18n.locale,username: @coupen.user.username), notice: 'Coupen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coupen
      @coupen = Coupen.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coupen_params
      params.require(:coupen).permit!
    end

    def branch_coupens(branches)
      branches.each do |branch|
        if params["coupen_type"].present?
          params["coupen_type"].each do |coupen_type|
            if branch.coupens.merge(BranchConnect.if_checked).collect(&:coupen_types).flatten.include? CoupenType.find(coupen_type)
              @coupens << branch.coupens.merge(BranchConnect.if_checked).running(session[:country])
            end
          end
        else
          @coupens << branch.coupens.merge(BranchConnect.if_checked).running(session[:country])
        end
      end 
    end
end
