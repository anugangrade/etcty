class VideoAdvsController < InheritedResources::Base
	before_action :set_video_adv, only: [:show, :edit, :update, :destroy]

  # GET /video_advs
  # GET /video_advs.json
  def index
    @sub_categories = VideoAdv.all_sub_categories
    @categories = @sub_categories.collect(&:category).uniq

    if params["category_id"].present? || params["sub_category_id"].present?
      if params["category_id"].present?
        category = Category.find(params["category_id"])
        stores = category.sub_categories.collect(&:stores).reject(&:blank?).flatten.uniq
      else
        sub_category = SubCategory.find(params["sub_category_id"])
        stores = sub_category.stores
      end
      @video_advs = stores.collect(&:branches).flatten.collect(&:video_advs)
    elsif params["store_id"].present? || (params[:location].present? && params[:location].values.reject(&:empty?).present?)
      store = Store.find(params["store_id"]) if params["store_id"].present?

      branches = store.present? ? (params[:location].values.reject(&:empty?).present? ? store.branches.in_location(params[:location]) : store.branches) : Branch.in_location(params[:location])

      @video_advs = branches.collect(&:video_advs)
    else
      @video_advs = VideoAdv.all
    end

    @video_advs = @video_advs.flatten.uniq
  end

  # GET /video_advs/new
  def new
    @video_adv = VideoAdv.new
    @stores = current_user.stores
    redirect_to new_store_path, notice: "You first have to create a Store before creating video_adv" if @stores.blank?
  end

  # POST /video_advs
  # POST /video_advs.json
  def create
    @video_adv = current_user.video_advs.new(video_adv_params)

    respond_to do |format|
      if @video_adv.save
        params["branch"].each {|branch_id| @video_adv.video_adv_branches.create(branch_id: branch_id)}
        format.html { redirect_to profile_path(username: @video_adv.user.username), notice: 'video_adv was successfully created.' }
        format.json { render :show, status: :created, location: @video_adv }
      else
        format.html { render :new }
        format.json { render json: @video_adv.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @stores = current_user.stores
  end

  # PATCH/PUT /video_advs/1
  # PATCH/PUT /video_advs/1.json
  def update
    respond_to do |format|
      if @video_adv.update(video_adv_params)
        format.html { redirect_to profile_path(username: @video_adv.user.username), notice: 'video_adv was successfully updated.' }
        format.json { render :show, status: :ok, location: @video_adv }
      else
        format.html { render :edit }
        format.json { render json: @video_adv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_advs/1
  # DELETE /video_advs/1.json
  def destroy
    @video_adv.destroy
    respond_to do |format|
      format.html { redirect_to profile_path(username: @video_adv.user.username), notice: 'video_adv was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_adv
      @video_adv = VideoAdv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_adv_params
      params.require(:video_adv).permit!
    end
end