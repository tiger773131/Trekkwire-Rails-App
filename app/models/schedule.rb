# == Schema Information
#
# Table name: schedules
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  name       :string
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
  has_many :schedule_availabilities, dependent: :destroy
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :schedules, partial: "schedules/index", locals: {schedule: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :schedules, target: dom_id(self, :index) }
end
