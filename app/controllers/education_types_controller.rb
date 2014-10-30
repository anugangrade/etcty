class EducationTypesController < ApplicationController
  before_action :set_education_type, only: [:show, :edit, :update, :destroy]

  # GET /education_types
  # GET /education_types.json
  def index
    @education_types = EducationType.all
  end

  # GET /education_types/1
  # GET /education_types/1.json
  def show
  end

  # GET /education_types/new
  def new
    @education_type = EducationType.new
  end

  # GET /education_types/1/edit
  def edit
  end

  # POST /education_types
  # POST /education_types.json
  def create
    @education_type = EducationType.new(education_type_params)

    respond_to do |format|
      if @education_type.save
        format.html { redirect_to education_types_url, notice: 'Education type was successfully created.' }
        format.json { render :show, status: :created, location: @education_type }
      else
        format.html { render :new }
        format.json { render json: @education_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /education_types/1
  # PATCH/PUT /education_types/1.json
  def update
    respond_to do |format|
      if @education_type.update(education_type_params)
        format.html { redirect_to education_types_url, notice: 'Education type was successfully updated.' }
        format.json { render :show, status: :ok, location: @education_type }
      else
        format.html { render :edit }
        format.json { render json: @education_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /education_types/1
  # DELETE /education_types/1.json
  def destroy
    @education_type.destroy
    respond_to do |format|
      format.html { redirect_to education_types_url, notice: 'Education type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_education_type
      @education_type = EducationType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def education_type_params
      params.require(:education_type).permit(:name, :amount)
    end
end
