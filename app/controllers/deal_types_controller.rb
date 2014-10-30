class DealTypesController < ApplicationController
  before_action :set_deal_type, only: [:show, :edit, :update, :destroy]

  # GET /deal_types
  # GET /deal_types.json
  def index
    @deal_types = DealType.all
  end

  # GET /deal_types/1
  # GET /deal_types/1.json
  def show
  end

  # GET /deal_types/new
  def new
    @deal_type = DealType.new
  end

  # GET /deal_types/1/edit
  def edit
  end

  # POST /deal_types
  # POST /deal_types.json
  def create
    @deal_type = DealType.new(deal_type_params)

    respond_to do |format|
      if @deal_type.save
        format.html { redirect_to deal_types_url, notice: 'Deal type was successfully created.' }
        format.json { render :show, status: :created, location: @deal_type }
      else
        format.html { render :new }
        format.json { render json: @deal_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_types/1
  # PATCH/PUT /deal_types/1.json
  def update
    respond_to do |format|
      if @deal_type.update(deal_type_params)
        format.html { redirect_to deal_types_url, notice: 'Deal type was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_type }
      else
        format.html { render :edit }
        format.json { render json: @deal_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_types/1
  # DELETE /deal_types/1.json
  def destroy
    @deal_type.destroy
    respond_to do |format|
      format.html { redirect_to deal_types_url, notice: 'Deal type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_type
      @deal_type = DealType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_type_params
      params.require(:deal_type).permit(:name, :amount)
    end
end
