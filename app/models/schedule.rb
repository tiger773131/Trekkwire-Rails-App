class Schedule < ApplicationRecord
  belongs_to :account
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :schedules, partial: "schedules/index", locals: {schedule: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :schedules, target: dom_id(self, :index) }
end
