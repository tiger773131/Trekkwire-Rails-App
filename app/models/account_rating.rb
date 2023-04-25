# == Schema Information
#
# Table name: account_ratings
#
#  id                :bigint           not null, primary key
#  rating            :float
#  review            :text
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_account_id :bigint           not null
#  target_account_id :bigint           not null
#
# Indexes
#
#  index_account_ratings_on_source_account_id  (source_account_id)
#  index_account_ratings_on_target_account_id  (target_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_account_id => accounts.id)
#  fk_rails_...  (target_account_id => accounts.id)
#
class AccountRating < ApplicationRecord
  belongs_to :target_account, class_name: 'Account'
  belongs_to :source_account, class_name: 'Account'
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :account_ratings, partial: "account_ratings/index", locals: {account_rating: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :account_ratings, target: dom_id(self, :index) }
end
