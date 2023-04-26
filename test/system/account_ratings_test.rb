require "application_system_test_case"

class AccountRatingsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    login_as @user, scope: :user
    @account_rating = account_ratings(:one)
  end

  test "visiting the index" do
    visit account_ratings_url
    assert_selector "h1", text: "Account Ratings"
  end

  test "creating a Account rating" do
    visit account_ratings_url
    click_on "New Account Rating"

    fill_in "Rating", with: @account_rating.rating
    fill_in "Review", with: @account_rating.review
    fill_in "Source account", with: @account_rating.source_account_id
    fill_in "Target account", with: @account_rating.target_account_id
    fill_in "Title", with: @account_rating.title
    click_on "Create Account rating"

    assert_text "Account rating was successfully created"
    assert_selector "h1", text: "Account Ratings"
  end

  test "updating a Account rating" do
    visit account_rating_url(@account_rating)
    click_on "Edit", match: :first

    fill_in "Rating", with: @account_rating.rating
    fill_in "Review", with: @account_rating.review
    fill_in "Source account", with: @account_rating.source_account_id
    fill_in "Target account", with: @account_rating.target_account_id
    fill_in "Title", with: @account_rating.title
    click_on "Update Account rating"

    assert_text "Account rating was successfully updated"
    assert_selector "h1", text: "Account Ratings"
  end

  test "destroying a Account rating" do
    visit edit_account_rating_url(@account_rating)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Account rating was successfully destroyed"
  end
end
