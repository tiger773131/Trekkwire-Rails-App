class AddPhoneToScheduledTour < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_tours, :phone, :bigint
  end
end
