class ScheduledTour < ApplicationRecord
  belongs_to :tour
  belongs_to :account_user
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :scheduled_tours, partial: "scheduled_tours/index", locals: {scheduled_tour: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :scheduled_tours, target: dom_id(self, :index) }
end
