# == Schema Information
#
# Table name: account_rating_details
#
#  id                  :bigint           not null, primary key
#  five_star_count     :integer
#  four_star_count     :integer
#  one_star_count      :integer
#  three_star_count    :integer
#  total_ratings       :integer
#  total_ratings_score :float
#  two_star_count      :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint           not null
#
# Indexes
#
#  index_account_rating_details_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class AccountRatingDetail < ApplicationRecord
  belongs_to :account
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :account_rating_details, partial: "account_rating_details/index", locals: {account_rating_detail: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :account_rating_details, target: dom_id(self, :index) }

  after_update do
    if total_ratings.to_i > 0
      update_column(:total_ratings_score, ((one_star_count.to_i * 1) + (two_star_count.to_i * 2) + (three_star_count.to_i * 3) + (four_star_count.to_i * 4) + (five_star_count.to_i * 5)) / total_ratings.to_i)
    end
  end
end
