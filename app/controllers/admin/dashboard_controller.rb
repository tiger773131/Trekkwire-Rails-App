module Admin
  class DashboardController < Admin::ApplicationController
    # See https://administrate-demo.herokuapp.com/customizing_controller_actions
    # for more information
    def show
      @total_revenue = total_revenue
      @last_12_mos = last_12_mos
      @last_month = last_month
      @this_month = this_month
      @users = ::User.all.count
      @users_last_month = users_last_month
      @users_last_12_mos = users_last_12_mos
      @users_this_month = users_this_month
      @guide_accounts = ::Account.where(customer_type: "guide").count
      @traveler_accounts = ::Account.where(customer_type: "traveler").count
      @scheduled_tours = ::ScheduledTour.where(paid: true).count
    end

    def total_revenue
      # revenue_in_cents = ::Pay::Charge.sum(:amount)
      # refunds_in_cents = ::Pay::Charge.sum(:amount_refunded)
      # (revenue_in_cents - refunds_in_cents) / 100.0
      ScheduledTour.where(paid: true).sum(:total_paid)
    end

    def last_12_mos
      revenue_for_range 12.months.ago..Time.current
    end

    def last_month
      month = Time.current.prev_month
      revenue_for_range month.beginning_of_month..month.end_of_month
    end

    def this_month
      month = Time.current
      revenue_for_range month.beginning_of_month..month.end_of_month
    end

    def users_last_month
      users_for_range Time.current.prev_month.beginning_of_month..Time.current.prev_month.end_of_month
    end

    def users_this_month
      users_for_range Time.current.beginning_of_month..Time.current.end_of_month
    end

    def users_last_12_mos
      users_for_range 12.months.ago..Time.current
    end

    def revenue_for_range(range)
      # revenue_in_cents = ::Pay::Charge.where(created_at: range).sum(:amount)
      # refunds_in_cents = ::Pay::Charge.where(created_at: range).sum(:amount_refunded)
      # (revenue_in_cents - refunds_in_cents) / 100.0
      ScheduledTour.where(paid: true, created_at: range).sum(:total_paid)
    end

    def users_for_range(range)
      ::User.where(created_at: range).count
    end
  end
end
