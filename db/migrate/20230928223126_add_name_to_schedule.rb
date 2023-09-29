class AddNameToSchedule < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :name, :string
  end
end
