class AddStripeAccountIdToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :stripe_account_id, :string
  end
end
