require "application_system_test_case"

class ToursTest < ApplicationSystemTestCase
  setup do
    @tour = tours(:one)
  end

  test "visiting the index" do
    visit tours_url
    assert_selector "h1", text: "Tours"
  end

  test "creating a Tour" do
    visit tours_url
    click_on "New Tour"

    fill_in "Account", with: @tour.account_id
    fill_in "Description", with: @tour.description
    fill_in "Title", with: @tour.title
    click_on "Create Tour"

    assert_text "Tour was successfully created"
    assert_selector "h1", text: "Tours"
  end

  test "updating a Tour" do
    visit tour_url(@tour)
    click_on "Edit", match: :first

    fill_in "Account", with: @tour.account_id
    fill_in "Description", with: @tour.description
    fill_in "Title", with: @tour.title
    click_on "Update Tour"

    assert_text "Tour was successfully updated"
    assert_selector "h1", text: "Tours"
  end

  test "destroying a Tour" do
    visit edit_tour_url(@tour)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Tour was successfully destroyed"
  end
end
