class AddDayAvailabilityToSchedule < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :begin_date, :date
    add_column :schedules, :end_date, :date
    add_column :schedules, :mon_start, :time
    add_column :schedules, :mon_end, :time
    add_column :schedules, :tue_start, :time
    add_column :schedules, :tue_end, :time
    add_column :schedules, :wed_start, :time
    add_column :schedules, :wed_end, :time
    add_column :schedules, :thu_start, :time
    add_column :schedules, :thu_end, :time
    add_column :schedules, :fri_start, :time
    add_column :schedules, :fri_end, :time
    add_column :schedules, :sat_start, :time
    add_column :schedules, :sat_end, :time
    add_column :schedules, :sun_start, :time
    add_column :schedules, :sun_end, :time
  end
end
