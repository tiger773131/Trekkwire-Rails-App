# == Schema Information
#
# Table name: account_language_taggings
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#  language_tag_id :bigint           not null
#
# Indexes
#
#  index_account_language_taggings_on_account_id       (account_id)
#  index_account_language_taggings_on_language_tag_id  (language_tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (language_tag_id => language_tags.id)
#
class AccountLanguageTagging < ApplicationRecord
  belongs_to :language_tag
  belongs_to :account

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :account_language_taggings, partial: "account_language_taggings/index", locals: {account_language_tagging: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :account_language_taggings, target: dom_id(self, :index) }
end
