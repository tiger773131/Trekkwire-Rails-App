class AddAssignedGuideIdToScheduledTours < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_tours, :assigned_guide_id, :integer, index: true
    add_foreign_key :scheduled_tours, :account_users, column: :assigned_guide_id
  end
end
