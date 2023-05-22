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
require "test_helper"

class ScheduleAvailabilityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
