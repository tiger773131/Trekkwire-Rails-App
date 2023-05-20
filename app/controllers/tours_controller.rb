class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /tours
  def index
    @pagy, @tours = pagy(Tour.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @tours
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
    params.require(:tour).permit(:title, :description, :account_id)

    # Uncomment to use Pundit permitted attributes
    # params.require(:tour).permit(policy(@tour).permitted_attributes)
  end
end
