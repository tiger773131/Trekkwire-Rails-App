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
require "test_helper"

class AccountRatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
