require "test_helper"

class ScheduledToursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scheduled_tour = scheduled_tours(:one)
    @user_two = users(:two)
    @tour = tours(:one)
    sign_in @user_two
  end

  test "should get index" do
    get scheduled_tours_url
    assert_response :success
  end

  test "should get new" do
    get new_scheduled_tour_url + "?tour_id=" + @tour.id.to_s
    assert_response :success
  end

  test "should redirect new if no params passed" do
    get new_scheduled_tour_url
    assert_redirected_to root_url
  end

  # test "should create scheduled_tour" do
  #   assert_difference("ScheduledTour.count") do
  #     post scheduled_tours_url, params: {scheduled_tour: {account_user_id: @scheduled_tour.account_user_id, location: @scheduled_tour.location, scheduled_date: @scheduled_tour.scheduled_date, scheduled_time: @scheduled_tour.scheduled_time, tour_id: @scheduled_tour.tour_id}}
  #   end
  #
  #   assert_redirected_to scheduled_tour_url(ScheduledTour.last)
  # end

  test "should show scheduled_tour" do
    get scheduled_tour_url(@scheduled_tour)
    assert_response :success
  end

  test "should get edit" do
    get edit_scheduled_tour_url(@scheduled_tour)
    assert_response :success
  end

  test "should update scheduled_tour" do
    patch scheduled_tour_url(@scheduled_tour), params: {scheduled_tour: {account_user_id: @scheduled_tour.account_user_id, location: @scheduled_tour.location, scheduled_date: @scheduled_tour.scheduled_date, phone: @scheduled_tour.phone, scheduled_time: @scheduled_tour.scheduled_time, tour_id: @scheduled_tour.tour_id}}
    assert_redirected_to scheduled_tour_url(@scheduled_tour)
  end

  test "should destroy scheduled_tour" do
    assert_difference("ScheduledTour.count", -1) do
      delete scheduled_tour_url(@scheduled_tour)
    end

    assert_redirected_to scheduled_tours_url
  end
end
