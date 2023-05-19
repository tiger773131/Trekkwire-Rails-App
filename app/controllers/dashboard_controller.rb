class DashboardController < ApplicationController
  def show
    if params[:bounds].present?
      bounds = JSON.parse(params[:bounds])
      account_ids = OperatingLocation.where(latitude: bounds["southWestLat"]..bounds["northEastLat"], longitude: bounds["southWestLng"]..bounds["northEastLng"]).map(&:account_id)
      @pagy, @guides = pagy(Account.where(id: account_ids, customer_type: 1))
    else
      @pagy, @guides = pagy(Account.where(customer_type: 1))
    end
  end

  def map_pins
    if params[:bounds].present?
      bounds = JSON.parse(params[:bounds])
      account_ids = OperatingLocation.where(latitude: bounds["southWestLat"]..bounds["northEastLat"], longitude: bounds["southWestLng"]..bounds["northEastLng"]).map(&:account_id)
      @pagy, @guides = pagy(Account.where(id: account_ids, customer_type: 1))
    else
      @pagy, @guides = pagy(Account.where(customer_type: 1))
    end
    render json: @guides, include: [:operating_location]
  end

  def page_list
    if params[:bounds].present?
      bounds = JSON.parse(params[:bounds])
      account_ids = OperatingLocation.where(latitude: bounds["southWestLat"]..bounds["northEastLat"], longitude: bounds["southWestLng"]..bounds["northEastLng"]).map(&:account_id)
      @pagy, @guides = pagy(Account.where(id: account_ids, customer_type: 1))
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("guides", partial: "dashboard/page_list")
        end
      end
    else
      @pagy, @guides = pagy(Account.where(customer_type: 1))
    end
  end
end
