# == Schema Information
#
# Table name: tours
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#
# Indexes
#
#  index_tours_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Tour < ApplicationRecord
  belongs_to :account
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :tours, partial: "tours/index", locals: {tour: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :tours, target: dom_id(self, :index) }
end
