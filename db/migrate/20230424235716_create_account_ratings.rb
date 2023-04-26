class CreateAccountRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :account_ratings do |t|
      t.references :target_account, null: false
      t.references :source_account, null: false
      t.string :title
      t.text :review
      t.float :rating

      t.timestamps
    end

    add_foreign_key :account_ratings, :accounts, column: :target_account_id
    add_foreign_key :account_ratings, :accounts, column: :source_account_id
  end
end
