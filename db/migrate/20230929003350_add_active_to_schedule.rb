class AddActiveToSchedule < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :active, :boolean, default: false
  end
end
