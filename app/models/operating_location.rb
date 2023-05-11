# == Schema Information
#
# Table name: operating_locations
#
#  id         :bigint           not null, primary key
#  address    :string
#  latitude   :decimal(10, 6)
#  longitude  :decimal(10, 6)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#
# Indexes
#
#  index_operating_locations_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class OperatingLocation < ApplicationRecord
  belongs_to :account
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :operating_locations, partial: "operating_locations/index", locals: {operating_location: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :operating_locations, target: dom_id(self, :index) }
end
