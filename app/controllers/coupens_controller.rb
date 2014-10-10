class CoupensController < InheritedResources::Base
	before_action :set_coupen, only: [:show, :edit, :update, :destroy]

  # GET /coupens
  # GET /coupens.json
  def index
    @sub_categories = Coupen.all_sub_categories
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
      @coupens = stores.collect(&:branches).flatten.collect(&:coupens)
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

      branches.each do |branch|
        if params["coupen_type"].present?
          params["coupen_type"].each do |coupen_type|
            if branch.coupens.collect(&:coupen_types).flatten.include? CoupenType.find(coupen_type)
              @coupens << branch.coupens
            end
          end
        else
          @coupens << branch.coupens
        end
      end
    elsif params["city"].present? && params["zip"].present?
      @coupens = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        if params["coupen_type"].present?
          params["coupen_type"].each do |coupen_type|
            if branch.coupens.collect(&:coupen_types).flatten.include? CoupenType.find(coupen_type)
              @coupens << branch.coupens
            end
          end
        else
          @coupens << branch.coupens
        end
      end
    elsif params["city"].present?
      @coupens = []
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        if params["coupen_type"].present?
          params["coupen_type"].each do |coupen_type|
            if branch.coupens.collect(&:coupen_types).flatten.include? CoupenType.find(coupen_type)
              @coupens << branch.coupens
            end
          end
        else
          @coupens << branch.coupens
        end
      end
    elsif params["zip"].present?
      @coupens = []
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        if params["coupen_type"].present?
          params["coupen_type"].each do |coupen_type|
            if branch.coupens.collect(&:coupen_types).flatten.include? CoupenType.find(coupen_type)
              @coupens << branch.coupens
            end
          end
        else
          @coupens << branch.coupens
        end
      end
    elsif params["coupen_type"].present?
      @coupens = []
      params["coupen_type"].each do |coupen_type|
        @coupens << CoupenType.find(coupen_type).coupens
      end
    else
      @coupens = Coupen.all
    end

    @coupens = @coupens.flatten.uniq.paginate(:page => params[:page], :per_page => 8)
  end

  # GET /coupens/1
  # GET /coupens/1.json
  def show
  end

  # GET /coupens/new
  def new
    @coupen = Coupen.new
    @coupen_types = CoupenType.all.limit(2)
    @stores = current_user.stores

    redirect_to new_store_path, notice: "You first have to create a Store before creating Coupen" if @stores.blank?
  end

  # GET /coupens/1/edit
  def edit
    @coupen_types = CoupenType.all.limit(2)
    @stores = current_user.stores

    @coupen_coupen_types = @coupen.coupen_types
    @coupen_branches = @coupen.branches
  end

  # POST /coupens
  # POST /coupens.json
  def create
    @coupen = current_user.coupens.new(coupen_params)

    respond_to do |format|
      if @coupen.save
        params["coupen_type"].each {|coupen_type_id| @coupen.coupen_connects.create(coupen_type_id: coupen_type_id)}
        params["branch"].each {|branch_id| @coupen.coupen_branches.create(branch_id: branch_id)}
        
        format.html { redirect_to profile_path(username: @coupen.user.username), notice: 'Coupen was successfully created.' }
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

        @not_required = @coupen.coupen_types.collect {|s| s.id.to_s} - params["coupen_type"]
        @not_required.each {|coupen_type_id| @coupen.coupen_connects.where(coupen_type_id:  coupen_type_id).destroy_all}
        params["coupen_type"].each {|coupen_type_id| @coupen.coupen_connects.create(coupen_type_id: coupen_type_id) if !@coupen.coupen_types.collect {|s| s.id.to_s}.include? coupen_type_id}
        
        @not_required = @coupen.branches.collect {|s| s.id.to_s} - params["branch"]
        @not_required.each {|branch_id| @coupen.coupen_branches.where(branch_id:  branch_id).destroy_all}
        params["branch"].each {|branch_id| @coupen.coupen_branches.create(branch_id: branch_id) if !@coupen.branches.collect {|s| s.id.to_s}.include? branch_id}
        



        format.html { redirect_to profile_path(username: @coupen.user.username), notice: 'Coupen was successfully updated.' }
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
      format.html { redirect_to profile_path(username: @coupen.user.username), notice: 'Coupen was successfully destroyed.' }
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
end
