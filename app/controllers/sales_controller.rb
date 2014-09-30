class SalesController < InheritedResources::Base

  def index
    @sub_categories = Sale.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq


    if params["category_id"].present? || params["sub_category_id"].present?
      @sales = []
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
        @sales << branch.sales
      end
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

    @sales = @sales.flatten.uniq
  end

  def new
    @sale = Sale.new
    @stores = current_user.stores
    @sale_types = SaleType.all.limit(2)
    redirect_to new_store_path, notice: "You first have to create a Store before creating banner" if @stores.blank?
  end


  def create
    @sale = current_user.sales.new(sale_params)

    respond_to do |format|
      if @sale.save
        params["sale_type"].each {|sale_type_id| @sale.sale_connects.create(sale_type_id: sale_type_id)}
        params["branch"].each {|branch_id| @sale.sale_branches.create(branch_id: branch_id)}
        
        format.html { redirect_to profile_path(username: @sale.user.username), notice: 'sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit!
    end

end
