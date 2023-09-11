# == Schema Information
#
# Table name: language_tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LanguageTag < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :language_tags, partial: "language_tags/index", locals: {language_tag: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :language_tags, target: dom_id(self, :index) }

  has_many :account_language_taggings, dependent: :destroy
  has_many :accounts, through: :account_language_taggings
end
