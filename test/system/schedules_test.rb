require "application_system_test_case"

class SchedulesTest < ApplicationSystemTestCase
  setup do
    @schedule = schedules(:one)
    @user = users(:guide_user)
    login_as @user, scope: :user
  end

  test "visiting the index" do
    visit schedules_url
    assert_selector "h1", text: "Schedules"
  end

  test "creating a Schedule" do
    visit schedules_url
    click_on "New Schedule"

    fill_in "Name", with: @schedule.name
    click_on "Create Schedule"

    # assert_text "Schedule was successfully created"
    assert_selector "h1", text: "Schedules"
  end

  test "updating a Schedule" do
    visit schedule_url(@schedule)
    click_on "Edit", match: :first

    fill_in "Name", with: @schedule.name
    click_on "Update Schedule"

    # assert_text "Schedule was successfully updated"
    assert_selector "h1", text: "Schedules"
  end

  test "destroying a Schedule" do
    visit edit_schedule_url(@schedule)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Schedule was successfully destroyed"
  end
end
