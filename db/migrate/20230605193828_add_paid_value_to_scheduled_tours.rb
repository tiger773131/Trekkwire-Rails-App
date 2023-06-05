class AddPaidValueToScheduledTours < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_tours, :paid, :boolean
  end
end
