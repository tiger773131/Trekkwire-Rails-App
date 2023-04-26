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
  enum rating: {one_star_count: 1.0, two_star_count: 2.0, three_star_count: 3.0, four_star_count: 4.0, five_star_count: 5.0}
  belongs_to :target_account, class_name: "Account"
  belongs_to :source_account, class_name: "Account"
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :account_ratings, partial: "account_ratings/index", locals: {account_rating: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :account_ratings, target: dom_id(self, :index) }

  after_create do
    rating_detail = AccountRatingDetail.find_or_create_by(account_id: target_account_id)
    rating_detail.increment!(:total_ratings)
    rating_detail.increment!(rating)
    rating_detail.save!
  end
end
