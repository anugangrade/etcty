class CoupensController < ApplicationController
	before_action :set_coupen, only: [:show, :edit, :update, :destroy]

  # GET /coupens
  # GET /coupens.json
  def index
    @coupens = Coupen.running(session[:country])
    @categories = @coupens.all_sub_categories.group_by(&:category)

    if params["category_id"].present? || params["sub_category_id"].present?
      stores = params["category_id"].present? ? Category.find(params["category_id"]).get_stores : SubCategory.find(params["sub_category_id"]).stores
      @coupens = stores.collect(&:branches).flatten.collect{ |b| b.coupens.running(session[:country])}
    elsif params["store_id"].present?
      @coupens = []
      store = Store.find(params["store_id"])
      branches = (params["city"].present? || params["zip"].present?) ? store.branches.in_location(params) : store.branches
      branch_coupens(branches)
    elsif params["city"].present? || params["zip"].present?
      @coupens = []
      branches = Branch.in_location(params)
      branch_coupens(branches)
    elsif params["coupen_type"].present?
      params["coupen_type"] = params["coupen_type"].split(",") if !params["coupen_type"].kind_of?(Array) 
      @coupens = []
      params["coupen_type"].each do |coupen_type|
        @coupens << CoupenType.find(coupen_type).coupens.running(session[:country])
      end
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
        coupens = branch.coupens.merge(BranchConnect.if_checked)
        coupen_type_ids = coupens.collect(&:coupen_types).flatten.uniq.collect(&:id)
        if params["coupen_type"].present?
          params["coupen_type"].each do |coupen_type|
            @coupens << coupens.running(session[:country]) if (coupen_type_ids.include? coupen_type.to_i)
          end
        else
          @coupens << coupens.running(session[:country])
        end
      end 
    end
end
