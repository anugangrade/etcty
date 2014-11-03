class EducationsController < ApplicationController
  before_action :set_education, only: [:show, :edit, :update, :destroy, :complete_order]


	def index
    @sub_categories = Education.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq

    params["education_type"] = params["education_type"].split(",") if params["education_type"].present? && !params["education_type"].kind_of?(Array) 

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @educations = stores.collect(&:branches).flatten.collect{ |b| b.educations.running}
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

      branch_educations(branches)
    elsif params["city"].present? && params["zip"].present?
      @educations = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branch_educations(branches)
    elsif params["city"].present?
      @educations = []
      branches = Branch.where("city = ?", params["city"] )
      branch_educations(branches)
    elsif params["zip"].present?
      @educations = []
      branches = Branch.where("zip = ?", params["zip"] )
      branch_educations(branches)
    elsif params["education_type"].present?
      @educations = []
      params["education_type"].each do |education_type|
        @educations << EducationType.find(education_type).educations.running
      end
    else
      @educations = Education.all.running
    end

    @educations = @educations.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  def new
    @education = Education.new
    @stores = current_user.stores
    @education_types = EducationType.all.limit(2)
    redirect_to new_store_path, notice: "You first have to create a Store before creating banner" if @stores.blank?
  end


  def create
    @education = current_user.educations.new(education_params)

    @education.save
    params["education_type"].each {|education_type_id| @education.education_connects.create(education_type_id: education_type_id)}
    params["branch"].each {|branch_id| @education.education_branches.create(branch_id: branch_id)}
    
    @education.transactions.create(user_id: @education.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_education_path(@education) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)
    redirect_to complete_order_education_path(@education)
  end

  def edit
    @education_types = EducationType.all.limit(4)
    @stores = @education.user.stores

    @education_education_types = @education.education_types
    @education_branches = @education.branches
  end

  def update
    respond_to do |format|
      if @education.update(education_params)

        @not_required = @education.education_types.collect {|s| s.id.to_s} - params["education_type"]
        @not_required.each {|education_type_id| @education.education_connects.where(education_type_id:  education_type_id).destroy_all}
        params["education_type"].each {|education_type_id| @education.education_connects.create(education_type_id: education_type_id) if !@education.education_types.collect {|s| s.id.to_s}.include? education_type_id}
        
        @not_required = @education.branches.collect {|s| s.id.to_s} - params["branch"]
        @not_required.each {|branch_id| @education.education_branches.where(branch_id:  branch_id).destroy_all}
        params["branch"].each {|branch_id| @education.education_branches.create(branch_id: branch_id) if !@education.branches.collect {|s| s.id.to_s}.include? branch_id}
        


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

  def complete_order
    # response = EXPRESS_GATEWAY.purchase((@education.transactions[0].amount)*100, {:token => params[:token],:payer_id => params[:PayerID]})
    # @education.transactions[0].update_attributes(paypal_token: params[:token], paypal_payer_id: params[:PayerID])
    @education.transactions[0].update_attributes(status: "paid")

    # if response.success?
    #   @education.transactions[0].update_attributes(status: "paid")
    # end
    # flash[:sucess] = response.success? ? "Congratulations, your education has been created" : "Oops!! Problem with the payment completion. Please try again"
    redirect_to profile_path(username: @education.user.username)
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

    def branch_educations(branches)
      branches.each do |branch|
        if params["education_type"].present?
          params["education_type"].each do |education_type|
            if branch.educations.collect(&:education_types).flatten.include? EducationType.find(education_type)
              @educations << branch.educations.running
            end
          end
        else
          @educations << branch.educations.running
        end
      end
    end
end
