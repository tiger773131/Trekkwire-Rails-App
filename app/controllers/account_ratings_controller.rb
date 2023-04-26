class AccountRatingsController < ApplicationController
  before_action :set_account_rating, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /account_ratings
  def index
    @pagy, @account_ratings = pagy(AccountRating.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @account_ratings
  end

  # GET /account_ratings/1 or /account_ratings/1.json
  def show
  end

  # GET /account_ratings/new
  def new
    @account_rating = AccountRating.new

    # Uncomment to authorize with Pundit
    # authorize @account_rating
  end

  # GET /account_ratings/1/edit
  def edit
  end

  # POST /account_ratings or /account_ratings.json
  def create
    @account_rating = AccountRating.new(account_rating_params)

    # Uncomment to authorize with Pundit
    # authorize @account_rating

    respond_to do |format|
      if @account_rating.save
        format.html { redirect_to @account_rating, notice: "Account rating was successfully created." }
        format.json { render :show, status: :created, location: @account_rating }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_ratings/1 or /account_ratings/1.json
  def update
    respond_to do |format|
      if @account_rating.update(account_rating_params)
        format.html { redirect_to @account_rating, notice: "Account rating was successfully updated." }
        format.json { render :show, status: :ok, location: @account_rating }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_ratings/1 or /account_ratings/1.json
  def destroy
    @account_rating.destroy
    respond_to do |format|
      format.html { redirect_to account_ratings_url, status: :see_other, notice: "Account rating was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account_rating
    @account_rating = AccountRating.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @account_rating
  rescue ActiveRecord::RecordNotFound
    redirect_to account_ratings_path
  end

  # Only allow a list of trusted parameters through.
  def account_rating_params
    params.require(:account_rating).permit(:target_account_id, :source_account_id, :title, :review, :rating)

    # Uncomment to use Pundit permitted attributes
    # params.require(:account_rating).permit(policy(@account_rating).permitted_attributes)
  end
end
