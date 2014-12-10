class EducationsController < ApplicationController
  before_action :set_education, only: [:show, :edit, :update, :destroy, :complete_order]


	def index
    @sub_categories = Education.all_sub_categories(session[:country])
    @categories = @sub_categories.collect(&:category).uniq

    params["education_type"] = params["education_type"].split(",") if params["education_type"].present? && !params["education_type"].kind_of?(Array) 

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        institutes = category.sub_categories.collect(&:institutes).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        institutes = sub_category.institutes
      end
      @educations = institutes.collect(&:branches).flatten.collect{ |b| b.educations.running(session[:country])}
    elsif params["institute_id"].present?
      @educations = []

      institute = Institute.find(params["institute_id"])
      if params["city"].present? || params["zip"].present?
        branches = institute.branches.in_location(params)
      elsif params["city"].present?
        branches = institute.branches.where("city = ?", params["city"] )
      elsif params["zip"].present?
        branches = institute.branches.where("zip = ?", params["zip"] )
      else
        branches = institute.branches
      end

      branch_educations(branches)
    elsif params["city"].present? || params["zip"].present?
      @educations = []
      branches = Branch.in_location(params)
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
        @educations << EducationType.find(education_type).educations.running(session[:country])
      end
    else
      @educations = Education.all.running(session[:country])
    end

    @educations = @educations.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  def new
    @education = Education.new
    EducationType.all.each do |a|
      @education.education_connects.build(education_type_id: a.id)
    end

    current_user.institutes.collect(&:branches).flatten.each do |branch|
      @education.branch_connects.build(branch_id: branch.id)
    end

    redirect_to new_institute_path(locale: I18n.locale), notice: "You first have to create a institute before creating banner" if current_user.institutes.blank?
  end


  def create
    @education = current_user.educations.create(education_params)    
    @education.transactions.create(user_id: @education.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_education_path(@education, locale: I18n.locale) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)
    redirect_to complete_order_education_path(@education, locale: I18n.locale)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @education.update(education_params)
        format.html { redirect_to profile_path(locale: I18n.locale,username: @education.user.username), notice: 'Education was successfully updated.' }
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
      format.html { redirect_to profile_path(locale: I18n.locale,username: @education.user.username), notice: 'Education was successfully destroyed.' }
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
    redirect_to profile_path(locale: I18n.locale,username: @education.user.username)
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
            if branch.educations.merge(BranchConnect.if_checked).collect(&:education_types).flatten.include? EducationType.find(education_type)
              @educations << branch.educations.merge(BranchConnect.if_checked).running(session[:country])
            end
          end
        else
          @educations << branch.educations.merge(BranchConnect.if_checked).running(session[:country])
        end
      end
    end
end
