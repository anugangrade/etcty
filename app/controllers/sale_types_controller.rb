class SaleTypesController < ApplicationController
  before_action :set_sale_type, only: [:show, :edit, :update, :destroy]

  # GET /sale_types
  # GET /sale_types.json
  def index
    @sale_types = SaleType.all
  end

  # GET /sale_types/1
  # GET /sale_types/1.json
  def show
  end

  # GET /sale_types/new
  def new
    @sale_type = SaleType.new
  end

  # GET /sale_types/1/edit
  def edit
  end

  # POST /sale_types
  # POST /sale_types.json
  def create
    @sale_type = SaleType.new(sale_type_params)

    respond_to do |format|
      if @sale_type.save
        format.html { redirect_to sale_types_url, notice: 'Sale type was successfully created.' }
        format.json { render :show, status: :created, location: @sale_type }
      else
        format.html { render :new }
        format.json { render json: @sale_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_types/1
  # PATCH/PUT /sale_types/1.json
  def update
    respond_to do |format|
      if @sale_type.update(sale_type_params)
        format.html { redirect_to sale_types_url, notice: 'Sale type was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale_type }
      else
        format.html { render :edit }
        format.json { render json: @sale_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_types/1
  # DELETE /sale_types/1.json
  def destroy
    @sale_type.destroy
    respond_to do |format|
      format.html { redirect_to sale_types_url, notice: 'Sale type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_type
      @sale_type = SaleType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_type_params
      params.require(:sale_type).permit(:name, :amount)
    end
end
