class AddAvailableNowToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :available_now, :boolean
  end
end
