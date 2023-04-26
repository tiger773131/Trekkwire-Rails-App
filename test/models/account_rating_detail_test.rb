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
require "test_helper"

class AccountRatingDetailTest < ActiveSupport::TestCase
  setup do
    @target_account = accounts(:company)
    @source_account = accounts(:one)
    AccountRating.create(source_account_id: @source_account.id, target_account_id: @target_account.id, rating: 5, title: "Test1", review: "Test")
    AccountRating.create(source_account_id: @source_account.id, target_account_id: @target_account.id, rating: 5, title: "Test2", review: "Test")
    AccountRating.create(source_account_id: @source_account.id, target_account_id: @target_account.id, rating: 5, title: "Test3", review: "Test")
  end

  test "has the correct average score" do
    @account_rating_detail = account_rating_details(:one)
    @maths = (((@account_rating_detail.five_star_count * 5) + (@account_rating_detail.four_star_count * 4) + (@account_rating_detail.three_star_count * 3) + (@account_rating_detail.two_star_count * 2) + (@account_rating_detail.one_star_count * 1)).to_f / @account_rating_detail.total_ratings).to_f
    assert_equal @maths, @account_rating_detail.total_ratings_score
  end

  test "has the incorrect average score" do
    @account_rating_detail = account_rating_details(:two)
    @maths = (((@account_rating_detail.five_star_count * 5) + (@account_rating_detail.four_star_count * 4) + (@account_rating_detail.three_star_count * 3) + (@account_rating_detail.two_star_count * 2) + (@account_rating_detail.one_star_count * 1)).to_f / @account_rating_detail.total_ratings).to_f
    assert_not_equal @maths, @account_rating_detail.total_ratings_score
  end

  test "Account ratings detail correctly updates on new ratings" do
    assert_equal 3, @target_account.account_rating_detail.total_ratings.to_i
    assert_equal 3, @target_account.account_rating_detail.five_star_count.to_i
    assert_equal 0, @target_account.account_rating_detail.four_star_count.to_i
    assert_equal 0, @target_account.account_rating_detail.three_star_count.to_i
    assert_equal 0, @target_account.account_rating_detail.two_star_count.to_i
    assert_equal 0, @target_account.account_rating_detail.one_star_count.to_i
  end

  test "Account total score correctly updates on new ratings" do
    assert_equal 5, @target_account.account_rating_detail.total_ratings_score.to_i
    AccountRating.create(source_account_id: @source_account.id, target_account_id: @target_account.id, rating: 1, title: "Test2", review: "Test")
    AccountRating.create(source_account_id: @source_account.id, target_account_id: @target_account.id, rating: 1, title: "Test2", review: "Test")
    AccountRating.create(source_account_id: @source_account.id, target_account_id: @target_account.id, rating: 1, title: "Test2", review: "Test")
    @target_account.account_rating_detail.reload
    assert_equal 3, @target_account.account_rating_detail.total_ratings_score.to_i
  end
end
