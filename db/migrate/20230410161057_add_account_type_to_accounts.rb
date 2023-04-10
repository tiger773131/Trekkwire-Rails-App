class AddAccountTypeToAccounts < ActiveRecord::Migration[7.0]
  def self.up
    add_column :accounts, :customer_type, :integer, default: 0
  end

  def self.down
    remove_column :accounts, :customer_type
  end
end
