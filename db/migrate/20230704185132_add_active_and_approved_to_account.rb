class AddActiveAndApprovedToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :active, :boolean
    add_column :accounts, :approved, :boolean
  end
end
