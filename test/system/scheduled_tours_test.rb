require "application_system_test_case"

class ScheduledToursTest < ApplicationSystemTestCase
  setup do
    @scheduled_tour = scheduled_tours(:one)
    @user = users(:guide_user)
    login_as @user, scope: :user
  end

  test "visiting the index" do
    visit scheduled_tours_url
    assert_selector "h1", text: "Scheduled Tours"
  end

  # test "creating a Scheduled tour" do
  #   visit new_scheduled_tour_url
  #   fill_in "Scheduled date", with: @scheduled_tour.scheduled_date
  #   fill_in "Scheduled time", with: @scheduled_tour.scheduled_time
  #   fill_in "Location", with: @scheduled_tour.location
  #   click_on "Create Scheduled tour"
  #
  #   # assert_text "Scheduled tour was successfully created"
  #   assert_selector "h1", text: "Scheduled Tours"
  # end
  #
  # test "updating a Scheduled tour" do
  #   visit scheduled_tour_url(@scheduled_tour)
  #   click_on "Edit", match: :first
  #
  #   fill_in "Scheduled date", with: @scheduled_tour.scheduled_date
  #   fill_in "Scheduled time", with: @scheduled_tour.scheduled_time
  #   fill_in "Location", with: @scheduled_tour.location
  #   click_on "Update Scheduled tour"
  #
  #   # assert_text "Scheduled tour was successfully updated"
  #   assert_selector "h1", text: "Scheduled Tours"
  # end
  test "destroying a Scheduled tour" do
    visit edit_scheduled_tour_url(@scheduled_tour)
    click_on "Delete", match: :first
    click_on "Confirm"

    # assert_text "Scheduled tour was successfully destroyed"
  end
end
