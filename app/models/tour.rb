# == Schema Information
#
# Table name: tours
#
#  id          :bigint           not null, primary key
#  description :text
#  price       :decimal(8, 2)
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
  has_many :scheduled_tours, dependent: :destroy
  has_many_attached :photos
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :tours, partial: "tours/index", locals: {tour: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :tours, target: dom_id(self, :index) }
  validates :price, :title, :description, :presence => true
end
