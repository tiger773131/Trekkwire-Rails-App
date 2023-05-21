class CreateScheduledTours < ActiveRecord::Migration[7.0]
  def change
    create_table :scheduled_tours do |t|
      t.date :scheduled_date
      t.time :scheduled_time
      t.string :location
      t.references :tour, null: false, foreign_key: true
      t.references :account_user, foreign_key: true

      t.timestamps
    end
  end
end
