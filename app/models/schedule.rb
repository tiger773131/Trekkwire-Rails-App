# == Schema Information
#
# Table name: schedules
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  begin_date :date
#  end_date   :date
#  fri_end    :time
#  fri_start  :time
#  mon_end    :time
#  mon_start  :time
#  name       :string
#  sat_end    :time
#  sat_start  :time
#  sun_end    :time
#  sun_start  :time
#  thu_end    :time
#  thu_start  :time
#  tue_end    :time
#  tue_start  :time
#  wed_end    :time
#  wed_start  :time
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#
# Indexes
#
#  index_schedules_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Schedule < ApplicationRecord
  belongs_to :account
  has_one :schedule_availability, dependent: :destroy
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :schedules, partial: "schedules/index", locals: {schedule: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :schedules, target: dom_id(self, :index) }
end
