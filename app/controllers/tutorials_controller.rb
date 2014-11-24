class TutorialsController < ApplicationController
  before_action :set_tutorial, only: [:show, :edit, :update, :destroy, :complete_order]

  # GET /tutorials
  # GET /tutorials.json
  def index
    @sub_categories = Tutorial.all_sub_categories(session[:country])
    @categories = @sub_categories.collect(&:category).uniq

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        institutes = category.sub_categories.collect(&:institutes).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        institutes = sub_category.institutes
      end
      @tutorials = institutes.collect(&:branches).flatten.collect{ |b| b.tutorials.running(session[:country])}
    elsif params["institute_id"].present?
      @tutorials = []

      institute = Institute.find(params["institute_id"])
      if params["city"].present? && params["zip"].present?
        branches = institute.branches.where("city = ? AND zip = ?", params["city"], params["zip"] )
      elsif params["city"].present?
        branches = institute.branches.where("city = ?", params["city"] )
      elsif params["zip"].present?
        branches = institute.branches.where("zip = ?", params["zip"] )
      else
        branches = institute.branches
      end

      branch_tutorials(branches)
    elsif params["city"].present? && params["zip"].present?
      @tutorials = []
      branches = Branch.where("city = ? AND zip = ?", params["city"], params["zip"] )
      branch_tutorials(branches)
    elsif params["city"].present?
      @tutorials = []
      branches = Branch.where("city = ?", params["city"] )
      branch_tutorials(branches)
    elsif params["zip"].present?
      @tutorials = []
      branches = Branch.where("zip = ?", params["zip"] )
      branch_tutorials(branches)
    else
      @tutorials = Tutorial.all.running(session[:country])
    end

    @tutorials = @tutorials.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /tutorials/1
  # GET /tutorials/1.json
  def show
  end

  # GET /tutorials/new
  def new
    @tutorial = Tutorial.new
    @institutes = current_user.institutes
    redirect_to new_institute_path(locale: I18n.locale), notice: "You first have to create a institute before creating banner" if @institutes.blank?
  end

  # GET /tutorials/1/edit
  def edit
    @institutes = @tutorial.user.institutes
    @tutorial_branches = @tutorial.branches
  end

  # POST /tutorials
  # POST /tutorials.json
  def create
    @tutorial = current_user.tutorials.new(tutorial_params)

    @tutorial.save
    params["branch"].each {|branch_id| @tutorial.tutorial_branches.create(branch_id: branch_id)}
    
    @tutorial.transactions.create(user_id: @tutorial.user_id, amount: params[:amount], currency: "USD", status: "pending")
    # base_url = (Rails.env == "development") ? 'http://localhost:3000' : 'http://www.etcty.com'

    # @response = EXPRESS_GATEWAY.setup_purchase((params[:amount].to_i*100),
    #   return_url: base_url+complete_order_tutorial_path(@tutorial, locale: I18n.locale) ,
    #   cancel_return_url: base_url,
    #   currency: "USD"
    # )

    # redirect_to EXPRESS_GATEWAY.redirect_url_for(@response.token)
    redirect_to complete_order_tutorial_path(@tutorial, locale: I18n.locale)
  end

  # PATCH/PUT /tutorials/1
  # PATCH/PUT /tutorials/1.json
  def update
    respond_to do |format|
      if @tutorial.update(tutorial_params)
        @not_required = @tutorial.branches.collect {|s| s.id.to_s} - params["branch"]
        @not_required.each {|branch_id| @tutorial.tutorial_branches.where(branch_id:  branch_id).destroy_all}
        params["branch"].each {|branch_id| @tutorial.tutorial_branches.create(branch_id: branch_id) if !@tutorial.branches.collect {|s| s.id.to_s}.include? branch_id}

        format.html { redirect_to profile_path(locale: I18n.locale,username: @tutorial.user.username), notice: 'tutorial was successfully updated.' }
        format.json { render :show, status: :ok, location: @tutorial }
      else
        format.html { render :edit }
        format.json { render json: @tutorial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutorials/1
  # DELETE /tutorials/1.json
  def destroy
    @tutorial.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(locale: I18n.locale,username: @tutorial.user.username), notice: 'tutorial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete_order
    # response = EXPRESS_GATEWAY.purchase((@tutorial.transactions[0].amount)*100, {:token => params[:token],:payer_id => params[:PayerID]})
    # @tutorial.transactions[0].update_attributes(paypal_token: params[:token], paypal_payer_id: params[:PayerID])
    @tutorial.transactions[0].update_attributes(status: "paid")

    # if response.success?
    #   @tutorial.transactions[0].update_attributes(status: "paid")
    # end
    # flash[:sucess] = response.success? ? "Congratulations, your tutorial has been created" : "Oops!! Problem with the payment completion. Please try again"
    redirect_to profile_path(locale: I18n.locale,username: @tutorial.user.username)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_tutorial
      @tutorial = Tutorial.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def tutorial_params
      params.require(:tutorial).permit!
    end

    def branch_tutorials(branches)
      branches.each do |branch|
        @tutorials << branch.tutorials.running(session[:country])
      end
    end
end