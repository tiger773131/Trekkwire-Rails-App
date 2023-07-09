class AddAccountCreatorToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :account_creator, :boolean
  end
end
