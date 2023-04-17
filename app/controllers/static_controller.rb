class StaticController < ApplicationController
  require 'sendgrid-ruby'
  include SendGrid
  def index
  end

  def about
  end

  def pricing
    redirect_to root_path, alert: t(".no_plans_html", link: helpers.link_to_if(current_user&.admin?, "Add a plan in the admin", admin_plans_path)) unless Plan.without_free.exists?

    plans = Plan.visible.sorted
    @monthly_plans = plans.select(&:monthly?)
    @yearly_plans = plans.select(&:yearly?)
  end

  def terms
    @agreement = Rails.application.config.agreements.find { _1.id == :terms_of_service }
  end

  def privacy
    @agreement = Rails.application.config.agreements.find { _1.id == :privacy_policy }
  end

  def add_email_contact
    sg = SendGrid::API.new(api_key: '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')
    data = JSON.parse('{
                                "list_ids": ["b00867d7-b423-4939-9b0c-fb0b225dc77a"],
                                "contacts": [
                                  {
                                    "email": "annahamilton@example.org",
                                  }
                                ]
                              }')
    response = sg.client.marketing.contacts.put(request_body: data)
    puts response.status_code
    puts response.headers
    puts response.body
    render root_path
  end
end
