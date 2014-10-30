class CoupenTypesController < ApplicationController
  before_action :set_coupen_type, only: [:show, :edit, :update, :destroy]

  # GET /coupen_types
  # GET /coupen_types.json
  def index
    @coupen_types = CoupenType.all
  end

  # GET /coupen_types/1
  # GET /coupen_types/1.json
  def show
  end

  # GET /coupen_types/new
  def new
    @coupen_type = CoupenType.new
  end

  # GET /coupen_types/1/edit
  def edit
  end

  # POST /coupen_types
  # POST /coupen_types.json
  def create
    @coupen_type = CoupenType.new(coupen_type_params)

    respond_to do |format|
      if @coupen_type.save
        format.html { redirect_to coupen_types_url, notice: 'Coupen type was successfully created.' }
        format.json { render :show, status: :created, location: @coupen_type }
      else
        format.html { render :new }
        format.json { render json: @coupen_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coupen_types/1
  # PATCH/PUT /coupen_types/1.json
  def update
    respond_to do |format|
      if @coupen_type.update(coupen_type_params)
        format.html { redirect_to coupen_types_url, notice: 'Coupen type was successfully updated.' }
        format.json { render :show, status: :ok, location: @coupen_type }
      else
        format.html { render :edit }
        format.json { render json: @coupen_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupen_types/1
  # DELETE /coupen_types/1.json
  def destroy
    @coupen_type.destroy
    respond_to do |format|
      format.html { redirect_to coupen_types_url, notice: 'Coupen type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coupen_type
      @coupen_type = CoupenType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coupen_type_params
      params.require(:coupen_type).permit(:name)
    end
end
