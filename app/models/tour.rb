# == Schema Information
#
# Table name: tours
#
#  id          :bigint           not null, primary key
#  description :text
#  duration    :integer
#  price       :decimal(8, 2)
#  tagline     :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#
# Indexes
#
#  index_tours_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

require "scheduling/scheduling_date_range"
class Tour < ApplicationRecord
  belongs_to :account
  has_many :scheduled_tours, dependent: :destroy
  has_many_attached :photos
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :tours, partial: "tours/index", locals: {tour: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :tours, target: dom_id(self, :index) }
  validates :price, :title, :description, :presence => true
  validates :photos, content_type: [:png, :jpg, :jpeg], size: {less_than: 4.megabytes, message: "must be less than 4MB in size"}

  def get_availability_for_date(date)
    schedule = account.schedules.where(active: true).first

    if schedule && (schedule.begin_date..schedule.end_date).cover?(date)
      booking_availability_for_date(date, schedule)
    else
      "There is no Scheduled Availability for guide for this date"
    end
  end

  ### This method will check for a given date, what the scheduled availability is, minus the bookings for that day
  def booking_availability_for_date(date, schedule)
    bookings = bookings_for_day(date)
    sfd = schedule_for_day(date, schedule)
    sched_hours = SchedulingDateRange(sfd["begin"]..sfd["end"]).every(hours: 1)
    final_hours = SchedulingDateRange(sfd["begin"]..sfd["end"]).every(hours: 1)
    sched_hours.each do |s|
      bookings.each do |b|
        if (b[:date]..(b[:date] + b[:duration].hours) - 1).cover?(s)
          puts "s to be removed #{s}"
          final_hours.delete(s)
        end
      end
    end
    formatted_hours_array(final_hours)
  end

  def bookings_for_day(date)
    account.scheduled_tours.where(scheduled_date: date).map { |booking| {date: booking.scheduled_time, duration: booking.tour.duration} }
  end

  def formatted_hours_array(dates)
    dates.each_with_index do |date, y|
      dates[y] = [date.strftime("%I:%M %p"), date]
    end
  end

  def schedule_for_day(date, schedule)
    if schedule.nil?
      nil
    else
      case date.wday
      when 0
        {"begin" => schedule.sun_start, "end" => schedule.sun_end, "day" => "Sunday"}
      when 1
        {"begin" => schedule.mon_start, "end" => schedule.mon_end, "day" => "Monday"}
      when 2
        {"begin" => schedule.tue_start, "end" => schedule.tue_end, "day" => "Tuesday"}
      when 3
        {"begin" => schedule.wed_start, "end" => schedule.wed_end, "day" => "Wednesday"}
      when 4
        {"begin" => schedule.thu_start, "end" => schedule.thu_end, "day" => "Thursday"}
      when 5
        {"begin" => schedule.fri_start, "end" => schedule.fri_end, "day" => "Friday"}
      when 6
        {"begin" => schedule.sat_start, "end" => schedule.sat_end, "day" => "Saturday"}
      else
        "Cannot determine the day of the week for #{date}"
      end
    end
  end
end
