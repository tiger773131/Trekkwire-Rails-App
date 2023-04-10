class AfterSignupController < ApplicationController
  include Wicked::Wizard
  steps(*User.form_steps)

  def show
    @user = current_user

    # case step
    # when :sign_up
    #   skip_step if @user.persisted?
    # when :user_type
    #   @user_account = @user.account.new
    # when :user_name
    # when :user_info
    # end
    # render_wizard
  end

  def update
    @user = current_user
    # case step
    # when "user_type"
    #   if @user.update(onboarding_params(step))
    #     render_wizard @user
    #   else
    #     render_wizard @user, status: :unprocessable_entity
    #   end
    # when "user_name"
    #   if @user.update(onboarding_params(step))
    #     render_wizard @user
    #   else
    #     render_wizard @user, status: :unprocessable_entity
    #   end
    # when "user_info"
    #   if @user.update(onboarding_params(step))
    #     render_wizard @user
    #   else
    #     render_wizard @user, status: :unprocessable_entity
    #   end
    # end
  end

  private

  def finish_wizard_path(params = nil)
    root_path
  end

  def onboarding_params(step = "sign_up")
    permitted_params = case step
    when "user_type"
      required_params = :user
      %i[user_type]
    when "user_name"
      required_params = :user
      %i[user_name]
    when "user_info"
      required_params = :user
      %i[user_info]
    end
    params.require(required_params).permit(permitted_params).merge(form_step: step)
  end
end
