require "test_helper"

class AccountRatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_rating = account_ratings(:one)
    @user_two = users(:two)
    sign_in @user_two
  end

  test "should get index" do
    get account_ratings_url
    assert_response :success
  end

  test "should get new" do
    get new_account_rating_url
    assert_response :success
  end

  test "should create account_rating" do
    assert_difference("AccountRating.count") do
      post account_ratings_url, params: {account_rating: {rating: @account_rating.rating, review: @account_rating.review, source_account_id: @account_rating.source_account_id, target_account_id: @account_rating.target_account_id, title: @account_rating.title}}
    end

    assert_redirected_to account_rating_url(AccountRating.last)
  end

  test "should show account_rating" do
    get account_rating_url(@account_rating)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_rating_url(@account_rating)
    assert_response :success
  end

  test "should update account_rating" do
    patch account_rating_url(@account_rating), params: {account_rating: {rating: @account_rating.rating, review: @account_rating.review, source_account_id: @account_rating.source_account_id, target_account_id: @account_rating.target_account_id, title: @account_rating.title}}
    assert_redirected_to account_rating_url(@account_rating)
  end

  test "should destroy account_rating" do
    assert_difference("AccountRating.count", -1) do
      delete account_rating_url(@account_rating)
    end

    assert_redirected_to account_ratings_url
  end
end
