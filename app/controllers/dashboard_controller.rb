class DashboardController < ApplicationController
  def show
    @pagy, @guides = pagy(Account.where(customer_type: 1))
  end
end
