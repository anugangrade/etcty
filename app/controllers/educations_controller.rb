class EducationsController < InheritedResources::Base
  before_action :set_education, only: [:show, :edit, :update, :destroy]


	def index
    @sub_categories = Education.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq


    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @educations = stores.collect(&:branches).flatten.collect(&:educations)
    elsif params["store_id"].present?
      @educations = []

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
        if params["education_type"].present?
          params["education_type"].each do |education_type|
            if branch.educations.collect(&:education_types).flatten.include? EducationType.find(education_type)
              @educations << branch.educations
            end
          end
        else
          @educations << branch.educations
        end
      end
    elsif params["city"].present? && params["zip"].present?
      @educations = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branches.each do |branch|
        if params["education_type"].present?
          params["education_type"].each do |education_type|
            if branch.educations.collect(&:education_types).flatten.include? EducationType.find(education_type)
              @educations << branch.educations
            end
          end
        else
          @educations << branch.educations
        end
      end
    elsif params["city"].present?
      @educations = []
      branches = Branch.where("city = ?", params["city"] )
      branches.each do |branch|
        if params["education_type"].present?
          params["education_type"].each do |education_type|
            if branch.educations.collect(&:education_types).flatten.include? EducationType.find(education_type)
              @educations << branch.educations
            end
          end
        else
          @educations << branch.educations
        end
      end
    elsif params["zip"].present?
      @educations = []
      branches = Branch.where("zip = ?", params["zip"] )
      branches.each do |branch|
        if params["education_type"].present?
          params["education_type"].each do |education_type|
            if branch.educations.collect(&:education_types).flatten.include? EducationType.find(education_type)
              @educations << branch.educations
            end
          end
        else
          @educations << branch.educations
        end
      end
    elsif params["education_type"].present?
      @educations = []
      params["education_type"].each do |education_type|
        @educations << EducationType.find(education_type).educations
      end
    else
      @educations = Education.all
    end

    @educations = @educations.flatten.uniq
  end

  def new
    @education = Education.new
    @stores = current_user.stores
    @education_types = EducationType.all.limit(2)
    redirect_to new_store_path, notice: "You first have to create a Store before creating banner" if @stores.blank?
  end


  def create
    @education = current_user.educations.new(education_params)

    respond_to do |format|
      if @education.save
        params["education_type"].each {|education_type_id| @education.education_connects.create(education_type_id: education_type_id)}
        params["branch"].each {|branch_id| @education.education_branches.create(branch_id: branch_id)}
        
        format.html { redirect_to profile_path(username: @education.user.username), notice: 'education was successfully created.' }
        format.json { render :show, status: :created, location: @education }
      else
        format.html { render :new }
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @education_types = EducationType.all.limit(4)
    @stores = current_user.stores
  end

  def update
    respond_to do |format|
      if @education.update(education_params)
        format.html { redirect_to profile_path(username: @education.user.username), notice: 'Advertisement was successfully updated.' }
        format.json { render :show, status: :ok, location: @education }
      else
        format.html { render :edit }
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @education.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(username: @education.user.username), notice: 'Education was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  	# Use callbacks to share common setup or constraints between actions.
    def set_education
      @education = Education.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def education_params
      params.require(:education).permit!
    end
end
