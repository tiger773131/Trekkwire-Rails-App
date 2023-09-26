class AddTotalPaidToScheduledTour < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_tours, :total_paid, :decimal, precision: 8, scale: 2
  end
end
