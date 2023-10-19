class AddStripeOnboardingToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :stripe_onboarded, :boolean
  end
end
