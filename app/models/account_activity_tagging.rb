# == Schema Information
#
# Table name: account_activity_taggings
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#  activity_tag_id :bigint           not null
#
# Indexes
#
#  index_account_activity_taggings_on_account_id       (account_id)
#  index_account_activity_taggings_on_activity_tag_id  (activity_tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (activity_tag_id => activity_tags.id)
#
class AccountActivityTagging < ApplicationRecord
  belongs_to :activity_tag
  belongs_to :account
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :account_activity_taggings, partial: "account_activity_taggings/index", locals: {account_activity_tagging: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :account_activity_taggings, target: dom_id(self, :index) }
end
