class DashboardController < ApplicationController
  def show
  end

  def map_pins
    if params[:bounds].present?
      bounds = JSON.parse(clean_bounds(params[:bounds]))
      account_ids = OperatingLocation.where(latitude: bounds["southWestLat"]..bounds["northEastLat"], longitude: bounds["southWestLng"]..bounds["northEastLng"]).map(&:account_id)
      @pagy, @guides = pagy(Account.where(id: account_ids, customer_type: 1, active: true, approved: true))
    else
      @pagy, @guides = pagy(Account.where(customer_type: 1))
    end
    render json: @guides, include: :operating_location, methods: :avatar_url
  end

  def page_list
    if params[:bounds].present?
      bounds = JSON.parse(clean_bounds(params[:bounds]))
      account_ids = OperatingLocation.where(latitude: bounds["southWestLat"]..bounds["northEastLat"], longitude: bounds["southWestLng"]..bounds["northEastLng"]).map(&:account_id)
      @pagy, @guides = pagy(Account.where(id: account_ids, customer_type: 1, active: true, approved: true))
    else
      @pagy, @guides = pagy(Account.where(customer_type: 1))
    end
  end
end

private

def clean_bounds(string)
  if params[:bounds].present? && params[:bounds].include?("?")
    params[:bounds].slice(0..(params[:bounds].index("?") - 1))
  else
    params[:bounds]
  end
end
