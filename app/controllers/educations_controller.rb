class EducationsController < ApplicationController
  before_action :set_education, only: [:show, :edit, :update, :destroy, :complete_order]


	def index
    @educations = Education.running(session[:country])
    @categories = @educations.all_sub_categories.group_by(&:category)

    if params["category_id"].present? || params["sub_category_id"].present?
      stores = params["category_id"].present? ? Category.find(params["category_id"]).get_institutes : SubCategory.find(params["sub_category_id"]).institutes
      @educations = institutes.collect(&:branches).flatten.collect{ |b| b.educations.running(session[:country])}
    elsif params["institute_id"].present?
      @educations = []
      institute = Institute.find(params["institute_id"])
      branches = (params["city"].present? || params["zip"].present?) ? institute.branches.in_location(params) : institute.branches
      branch_educations(branches)
    elsif params["city"].present? || params["zip"].present?
      @educations = []
      branches = Branch.in_location(params)
      branch_educations(branches)
    elsif params["education_type"].present?
      params["education_type"] = params["education_type"].split(",") if !params["education_type"].kind_of?(Array) 
      @educations = []
      params["education_type"].each do |education_type|
        @educations << EducationType.find(education_type).educations.running(session[:country])
      end
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
        educations = branch.educations.merge(BranchConnect.if_checked)
        educations_running = educations.running(session[:country])
        
        if params["education_type"].present?
          education_types = educations.collect(&:education_types).flatten.uniq.collect(&:id)
          params["education_type"].each do |education_type|
            @educations << educations_running if education_types.include? education_type.to_i
          end
        else
          @educations << educations_running
        end
      end
    end
end
