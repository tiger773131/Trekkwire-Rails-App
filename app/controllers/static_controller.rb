class StaticController < ApplicationController
  require 'sendgrid-ruby'
  include SendGrid
  def index
  end

  def about
  end

  def pricing
    redirect_to root_path, alert: t('.no_plans_html', link: helpers.link_to_if(current_user&.admin?, 'Add a plan in the admin', admin_plans_path)) unless Plan.without_free.exists?

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
    sg = SendGrid::API.new(api_key: Rails.application.credentials[:sendgrid_contact_list][:api_key])
    list_id = Rails.application.credentials[:sendgrid_contact_list][:list_id]
    email = params[:email]
    data = { list_ids: [list_id], contacts: [{ email: email }] }.to_json
    begin
      response = sg.client.marketing.contacts.put(request_body: data)
    rescue StandardError => e
      puts e.message
    else
      puts response.status_code
      puts response.headers
      puts response.body
      flash[:notice] = 'Thank you for your interest. We will be in touch soon.'
      redirect_to root_path
    end
  end
end
