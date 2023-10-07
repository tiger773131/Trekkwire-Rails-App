class ScheduledToursController < ApplicationController
  before_action :set_scheduled_tour, only: [:show, :edit, :update, :destroy]
  before_action :only_authorized, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /scheduled_tours
  def index
    @pagy, @scheduled_tours = pagy(ScheduledTour.where(account_user_id: current_account_user.id).sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @scheduled_tours
  end

  # GET /scheduled_tours/1 or /scheduled_tours/1.json
  def show
  end

  # GET /scheduled_tours/new
  def new
    if params[:tour_id]
      @tour = Tour.find_by_id(params[:tour_id])
      @scheduled_tour = ScheduledTour.new
      @scheduled_tour.tour = @tour
    else
      redirect_to root_path
      flash[:notice] = "You must select a tour to schedule a tour."
    end
    # Uncomment to authorize with Pundit
    # authorize @scheduled_tour
  end

  # GET /scheduled_tours/1/edit
  def edit
    @tour = @scheduled_tour.tour
  end

  # POST /scheduled_tours or /scheduled_tours.json
  def create
    @scheduled_tour = ScheduledTour.new(scheduled_tour_params)
    # Uncomment to authorize with Pundit
    # authorize @scheduled_tour

    respond_to do |format|
      if @scheduled_tour.save
        format.html do
          logo_img = "https://www.trekkwire.com/assets/Trekkwire-c73296d968061a6af217e717fc97651eed296354a8deabd05599d9a6a8257c80.png"
          image_url = @scheduled_tour.tour.account.avatar.attached? ? @scheduled_tour.tour.account.avatar.url : logo_img
          session = Stripe::Checkout::Session.create({
            payment_method_types: ["card", "cashapp"],
            line_items: [{
              price_data: {
                currency: "usd",
                product_data: {
                  name: @scheduled_tour.tour.title,
                  images: [image_url],
                  metadata: {
                    tour_id: @scheduled_tour.tour.id,
                    scheduled_tour_id: @scheduled_tour.id,
                    vendor_id: @scheduled_tour.tour.account.id,
                    vendor_name: @scheduled_tour.tour.account.name,
                    vendor_email: @scheduled_tour.tour.account.owner.email,
                    vendor_phone: @scheduled_tour.tour.account.owner.phone
                  }
                },
                tax_behavior: "inclusive",
                unit_amount: (@scheduled_tour.tour.price * 100).to_i
              },
              quantity: 1
            }],
            mode: "payment",
            success_url: success_url + "?scheduled_tour_id=" + @scheduled_tour.id.to_s + "&session_id={CHECKOUT_SESSION_ID}",
            cancel_url: cancel_url + "?scheduled_tour_id=" + @scheduled_tour.id.to_s,
            automatic_tax: {enabled: true},
            customer_email: current_user.email
          })
          redirect_to session.url, allow_other_host: true, notice: "Scheduled tour was successfully created."
        end
        format.json { render :show, status: :created, location: @scheduled_tour }
      else
        @tour = Tour.find_by_id(params[:tour_id])
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scheduled_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scheduled_tours/1 or /scheduled_tours/1.json
  def update
    @tour = @scheduled_tour.tour
    respond_to do |format|
      if @scheduled_tour.update(scheduled_tour_params)
        format.html { redirect_to @scheduled_tour, notice: "Scheduled tour was successfully updated." }
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
      format.html do
        redirect_to scheduled_tours_url, status: :see_other, notice: "Scheduled tour was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  def stripe_success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @scheduled_tour = ScheduledTour.find(params[:scheduled_tour_id])
    ScheduledTourNotification.with(account: @scheduled_tour.tour.account, user: current_user,
      scheduled_tour: @scheduled_tour).deliver_later(@scheduled_tour.tour.account.users.all)
    @scheduled_tour.update(paid: true, assigned_guide_id: @scheduled_tour.tour.account.users.first.id, total_paid: session["amount_total"] / 100.0)
  end

  def stripe_cancel
    @scheduled_tour = ScheduledTour.find(params[:scheduled_tour_id])
    @scheduled_tour.update(paid: false)
  end

  def availability
    @target = params[:target]
    @tour = Tour.find(params[:tour_id])
    @availability = @tour.get_availability_for_date(params[:date].to_date)
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scheduled_tour
    @scheduled_tour = ScheduledTour.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @scheduled_tour
  rescue ActiveRecord::RecordNotFound
    redirect_to scheduled_tours_url
  end

  def only_authorized
    redirect_to root_path, notice: "Not Authorized to View Page" unless current_account_user.id == @scheduled_tour.account_user_id || current_account == @scheduled_tour.tour.account
  end

  # Only allow a list of trusted parameters through.
  def scheduled_tour_params
    scheduled_tour = params.require(:scheduled_tour).permit(:scheduled_date, :scheduled_time, :phone, :location, :tour_id,
      :account_user_id, :assigned_guide_id)
    unless params[:tour_id].blank?
      scheduled_tour[:tour_id] = params[:tour_id]
    end
    unless params[:account_user_id].blank?
      scheduled_tour[:account_user_id] = params[:account_user_id]
    end
    scheduled_tour
    # Uncomment to use Pundit permitted attributes
    # params.require(:scheduled_tour).permit(policy(@scheduled_tour).permitted_attributes)
  end
end
