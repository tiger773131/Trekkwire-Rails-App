class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy, :delete_photo_attachment]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /tours
  def index
    @owned_account = false
    if params[:account_id].present?
      @pagy, @tours = pagy(Tour.where(account_id: params[:account_id]).sort_by_params(params[:sort], sort_direction))
    else
      @owned_account = true
      @pagy, @tours = pagy(current_account.tours.sort_by_params(params[:sort], sort_direction))
    end

    # Uncomment to authorize with Pundit
    # authorize @tours
  end

  def guide_tours
    @pagy, @tours = pagy(Tour.where(account_id: params[:guide_id]).sort_by_params(params[:sort], sort_direction))
  end

  # GET /tours/1 or /tours/1.json
  def show
  end

  # GET /tours/new
  def new
    @tour = Tour.new

    # Uncomment to authorize with Pundit
    # authorize @tour
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours or /tours.json
  def create
    @tour = Tour.new(tour_params)

    # Uncomment to authorize with Pundit
    # authorize @tour

    respond_to do |format|
      if @tour.save
        format.html { redirect_to @tour, notice: "Tour was successfully created." }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1 or /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: "Tour was successfully updated." }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1 or /tours/1.json
  def destroy
    @tour.destroy
    respond_to do |format|
      format.html { redirect_to tours_url, status: :see_other, notice: "Tour was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_photo_attachment
    params[:photos].each do |photo|
      @tour.photos.find(photo).purge
    end
    redirect_to edit_tour_path(@tour), notice: "Photo deleted"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @tour
  rescue ActiveRecord::RecordNotFound
    redirect_to tours_path
  end

  # Only allow a list of trusted parameters through.
  def tour_params
    params.require(:tour).permit(:title, :tagline, :description, :duration, :price, photos: []).merge(account_id: current_account.id)

    # Uncomment to use Pundit permitted attributes
    # params.require(:tour).permit(policy(@tour).permitted_attributes)
  end
end
