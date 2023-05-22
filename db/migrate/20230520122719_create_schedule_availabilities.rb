class CreateScheduleAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_availabilities do |t|
      t.references :schedule, null: false, foreign_key: true
      t.date :begin_date
      t.date :end_date
      t.time :begin_time
      t.time :end_time

      t.timestamps
    end
  end
end
