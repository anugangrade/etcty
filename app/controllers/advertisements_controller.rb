class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]

  # GET /advertisements
  # GET /advertisements.json
  def index
    @advertisements = Advertisement.all
  end

  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
  end

  # GET /advertisements/new
  def new
    @advertisement = Advertisement.new
    @zones = Zone.all.limit(9)
    @stores = current_user.stores
    redirect_to new_store_path, notice: "You first have to create a Store before creating advertisement" if @stores.blank?
  end

  # GET /advertisements/1/edit
  def edit
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = current_user.advertisements.new(advertisement_params)

    respond_to do |format|
      if @advertisement.save
        params["zone"].each {|zone_id| @advertisement.adv_zones.create(zone_id: zone_id)}
        params["branch"].each {|branch_id| @advertisement.adv_branches.create(branch_id: branch_id)}

        format.html { redirect_to profile_path(username: @advertisement.user.username), notice: 'Advertisement was successfully created.' }
        format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        format.html { redirect_to profile_path(username: @advertisement.user.username), notice: 'Advertisement was successfully updated.' }
        format.json { render :show, status: :ok, location: @advertisement }
      else
        format.html { render :edit }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisements/1
  # DELETE /advertisements/1.json
  def destroy
    @advertisement.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(username: @advertisement.user.username), notice: 'Advertisement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertisement
      @advertisement = Advertisement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advertisement_params
      params.require(:advertisement).permit!
    end
end
