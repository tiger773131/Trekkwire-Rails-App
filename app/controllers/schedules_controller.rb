class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /schedules
  def index
    @pagy, @schedules = pagy(Schedule.where(account_id: current_account.id).sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @schedules
  end

  # GET /schedules/1 or /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new

    # Uncomment to authorize with Pundit
    # authorize @schedule
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules or /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.account = current_account
    # Uncomment to authorize with Pundit
    # authorize @schedule

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: "Schedule was successfully created." }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1 or /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: "Schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1 or /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, status: :see_other, notice: "Schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_schedule
    @schedule = Schedule.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @schedule
  rescue ActiveRecord::RecordNotFound
    redirect_to schedules_path
  end

  # Only allow a list of trusted parameters through.
  def schedule_params
    params.require(:schedule).permit(:name, :active, :begin_date, :end_date, :mon_start, :mon_end, :tue_start, :tue_end, :wed_start, :wed_end, :thu_start, :thu_end, :fri_start, :fri_end, :sat_start, :sat_end, :sun_start, :sun_end)

    # Uncomment to use Pundit permitted attributes
    # params.require(:schedule).permit(policy(@schedule).permitted_attributes)
  end
end
