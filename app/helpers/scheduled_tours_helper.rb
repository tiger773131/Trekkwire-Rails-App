module ScheduledToursHelper
  def scheduled_tour_availability(date, tour)
    bookings = tour.scheduled_tours.where(scheduled_date: date)
    schedule = Schedule.where(account_id: tour.account_id, active: true).first

    if schedule.nil?
      return "No schedule available"
    end

    puts "hello"
    
  end

  def bookings(date)
  end

  def availability_for_day(date, schedule)
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

  def remaining_availability(bookings, schedule)
    
  end
end
