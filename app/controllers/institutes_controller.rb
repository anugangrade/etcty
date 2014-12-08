class InstitutesController < ApplicationController
  before_action :set_institute, only: [:show, :edit, :update, :destroy]

  # GET /institutes
  # GET /institutes.json
  def index
    @sub_categories = Institute.within_country(session[:country]).all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq


    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        @category = Category.find(params["category_id"])
        @institutes = @category.sub_categories.collect(&:institutes).reject(&:blank?).flatten.uniq
      else
        @sub_category = SubCategory.find(params["sub_category_id"])
        @institutes = @sub_category.institutes.within_country(session[:country])
      end
    elsif params["institute_id"].present? || (params[:location].present? && params[:location].values.reject(&:empty?).present?)
      institute = Institute.find(params["institute_id"]) if params["institute_id"].present?
      
      branches = institute.present? ? (params[:location].values.reject(&:empty?).present? ? institute.branches.where(country: session[:country], branchable_type: "Institute").in_location(params[:location]) : institute.branches.where(country: session[:country])) : Branch.where(country: session[:country], branchable_type: "Institute").in_location(params[:location])
      
      @institutes = branches.collect(&:branchable)
    else
      @institutes = Institute.within_country(session[:country])
    end
    @institutes = @institutes.flatten.uniq.paginate(:page => params[:page], :per_page => 12)
  
  end

  # GET /institutes/1
  # GET /institutes/1.json
  def show
    @categories =  @institute.sub_categories.collect(&:category).uniq

    if params["branch_id"].present?
      branch = Branch.find(params["branch_id"])
      @educations = branch.educations.merge(branch_connect_checked)
      @tutorials = branch.tutorials.merge(branch_connect_checked)
    else
      @educations = @institute.branches.collect(&:educations).merge(branch_connect_checked).flatten.uniq
      @tutorials = @institute.branches.collect(&:tutorials).merge(branch_connect_checked).flatten.uniq
    end

  end

  # GET /institutes/new
  def new
    @institute = current_user.institutes.build
    @institute.branches.build
  end

  # GET /institutes/1/edit
  def edit
  end

  # POST /institutes
  # POST /institutes.json
  def create
    @institute = current_user.institutes.new(institute_params)

    respond_to do |format|
      if @institute.save
        params["sub_categories_id"].split(",").each {|sub_category_id| @institute.institute_sub_categories.create(sub_category_id: sub_category_id)}
        format.html { redirect_to profile_path(locale: I18n.locale,username: @institute.user.username) , notice: 'Institute was successfully created.' }
        format.json { render :show, status: :created, location: @institute }
      else
        format.html { render :new }
        format.json { render json: @institute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /institutes/1
  # PATCH/PUT /institutes/1.json
  def update
    respond_to do |format|
      if @institute.update(institute_params)
        if params["sub_categories_id"].present? 
          @not_required = @institute.sub_categories.collect {|s| s.id.to_s} - params["sub_categories_id"].split(",")
          @not_required.each {|sub_category_id| @institute.institute_sub_categories.where(sub_category_id:  sub_category_id).destroy_all}
          params["sub_categories_id"].split(",").each {|sub_category_id| @institute.institute_sub_categories.create(sub_category_id: sub_category_id) if !@institute.sub_categories.collect {|s| s.id.to_s}.include? sub_category_id}
        end

        format.html { redirect_to profile_path(locale: I18n.locale,username: @institute.user.username), notice: 'Institute was successfully updated.' }
        format.json { render :show, status: :ok, location: @institute }
      else
        format.html { render :edit }
        format.json { render json: @institute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /institutes/1
  # DELETE /institutes/1.json
  def destroy
    @institute.destroy
    respond_to do |format|
      format.html { redirect_to institutes_url, notice: 'Institute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institute
      @institute = Institute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institute_params
      params.require(:institute).permit!
    end
end
