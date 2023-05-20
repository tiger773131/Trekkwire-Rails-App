# == Schema Information
#
# Table name: schedule_availabilities
#
#  id          :bigint           not null, primary key
#  begin_date  :date
#  begin_time  :time
#  end_date    :date
#  end_time    :time
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  schedule_id :bigint           not null
#
# Indexes
#
#  index_schedule_availabilities_on_schedule_id  (schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (schedule_id => schedules.id)
#
class ScheduleAvailability < ApplicationRecord
  belongs_to :schedule
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :schedule_availabilities, partial: "schedule_availabilities/index", locals: {schedule_availability: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :schedule_availabilities, target: dom_id(self, :index) }
end
