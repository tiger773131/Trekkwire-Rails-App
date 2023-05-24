class ScheduledToursController < ApplicationController
  before_action :set_scheduled_tour, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /scheduled_tours
  def index
    @pagy, @scheduled_tours = pagy(ScheduledTour.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @scheduled_tours
  end

  # GET /scheduled_tours/1 or /scheduled_tours/1.json
  def show
  end

  # GET /scheduled_tours/new
  def new
    @tour = Tour.find_by_id(params[:tour_id])
    @scheduled_tour = ScheduledTour.new

    # Uncomment to authorize with Pundit
    # authorize @scheduled_tour
  end

  # GET /scheduled_tours/1/edit
  def edit
  end

  # POST /scheduled_tours or /scheduled_tours.json
  def create
    @scheduled_tour = ScheduledTour.new(scheduled_tour_params)

    # Uncomment to authorize with Pundit
    # authorize @scheduled_tour

    respond_to do |format|
      if @scheduled_tour.save
        ScheduledTourNotification.with(account: @scheduled_tour.tour.account, user: current_user, 
                                       scheduled_tour: @scheduled_tour).deliver_later(@scheduled_tour.tour.account.users.all)
        format.html { redirect_to @scheduled_tour, notice: 'Scheduled tour was successfully created.' }
        format.json { render :show, status: :created, location: @scheduled_tour }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scheduled_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scheduled_tours/1 or /scheduled_tours/1.json
  def update
    respond_to do |format|
      if @scheduled_tour.update(scheduled_tour_params)
        format.html { redirect_to @scheduled_tour, notice: 'Scheduled tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduled_tour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scheduled_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_tours/1 or /scheduled_tours/1.json
  def destroy
    @scheduled_tour.destroy
    respond_to do |format|
      format.html {
 redirect_to scheduled_tours_url, status: :see_other, notice: 'Scheduled tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scheduled_tour
    @scheduled_tour = ScheduledTour.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @scheduled_tour
  rescue ActiveRecord::RecordNotFound
    redirect_to scheduled_tours_path
  end

  # Only allow a list of trusted parameters through.
  def scheduled_tour_params
    scheduled_tour = params.require(:scheduled_tour).permit(:scheduled_date, :scheduled_time, :location, :tour_id, 
                                                            :account_user_id)
    unless params[:tour_id].blank?
      scheduled_tour[:tour_id] = params[:tour_id]
    end
    scheduled_tour
    # Uncomment to use Pundit permitted attributes
    # params.require(:scheduled_tour).permit(policy(@scheduled_tour).permitted_attributes)
  end
end
