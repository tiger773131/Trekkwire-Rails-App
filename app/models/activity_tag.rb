# == Schema Information
#
# Table name: activity_tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ActivityTag < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :activity_tags, partial: "activity_tags/index", locals: {activity_tag: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :activity_tags, target: dom_id(self, :index) }

  has_many :account_activity_taggings, dependent: :destroy
  has_many :accounts, through: :account_activity_taggings
end
