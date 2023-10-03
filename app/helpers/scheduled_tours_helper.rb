module ScheduledToursHelper
  def scheduled_tour_availability(date, tour)
    bookings = tour.account.scheduled_tours.where(scheduled_date: date).map {|booking|  {date: booking.scheduled_time, duration: booking.tour.duration}}
    schedule = tour.account.schedules.where(active: true).first
    if (schedule && (schedule.begin_date..schedule.end_date).cover?(date))
      remaining_availability(date, bookings, schedule, tour.duration)
    else
      "There is no Scheduled Availability for guide for this date"
    end
  end

  def availability_for_day(date, schedule)

    if schedule.nil?
      return nil
    else
      case date.wday
      when 0
        return {"begin" => schedule.sun_start, "end" => schedule.sun_end, "day" => "Sunday"}
      when 1
        return {"begin" => schedule.mon_start, "end" => schedule.mon_end, "day" => "Monday"}
      when 2
        return {"begin" => schedule.tue_start, "end" => schedule.tue_end, "day" => "Tuesday"}
      when 3
        return {"begin" => schedule.wed_start, "end" => schedule.wed_end, "day" => "Wednesday"}
      when 4
        return {"begin" => schedule.thu_start, "end" => schedule.thu_end, "day" => "Thursday"}
      when 5
        return {"begin" => schedule.fri_start, "end" => schedule.fri_end, "day" => "Friday"}
      when 6
        return {"begin" => schedule.sat_start, "end" => schedule.sat_end, "day" => "Saturday"}
      else
        return "Cannot determine the day of the week for #{date}"
      end
    end
  end

  def remaining_availability(date, bookings, schedule, duration)
    final_avail = []
    hrs_slice = (available_schedule_hours(date, schedule) - booking_hours(bookings)).slice_when { |prev, curr| curr != prev.next }.to_a
    hrs_slice.each do |slice|
      if slice.length >= duration && duration > 0
        slice.pop(duration-1)
        final_avail.concat(slice)
      end
    end
    final_avail.each_with_index.map { |x,y| final_avail[y] = [ "Sat, 01 Jan 2000 #{x}:00:00.000000000 UTC +00:00".to_datetime.strftime("%I:%M %p"), "Sat, 01 Jan 2000 #{x}:00:00.000000000 UTC +00:00".to_datetime ] }
  end

  def available_schedule_hours(date, schedule)
    schedule_availability = availability_for_day(date, schedule)
    sched_hour_begin = schedule_availability["begin"].hour
    sched_hour_end = schedule_availability["end"].hour

    (sched_hour_begin..sched_hour_end).to_a
  end

  def booking_hours(bookings)
    hours = []
    bookings.each do |b|
      b_start = b[:date].hour
      b_end = b_start + b[:duration]
      arr= (b_start..b_end).to_a
      hours.concat(arr)
     end
     hours.uniq
  end

  def convert_to_time(hours)
    
  end
end
