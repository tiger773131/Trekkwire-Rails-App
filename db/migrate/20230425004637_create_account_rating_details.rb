class CreateAccountRatingDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :account_rating_details do |t|
      t.integer :five_star_count
      t.integer :four_star_count
      t.integer :three_star_count
      t.integer :two_star_count
      t.integer :one_star_count
      t.integer :total_ratings
      t.float :total_ratings_score
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
