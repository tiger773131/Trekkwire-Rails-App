require "active_support/all"
class Scheduling::SchedulingDateRange < Range
  # step is similar to DateTime#advance argument
  def every(step, &block)
    c_time = self.begin.to_datetime
    finish_time = self.end.to_datetime
    foo_compare = exclude_end? ? :< : :<=

    arr = []
    while c_time.send(foo_compare, finish_time)
      arr << c_time
      c_time = c_time.advance(step)
    end

    arr
  end
end

# Convenience method: Call with Scheduling.SchedulingDateRange(date1..date2).every(hours: 1)
def SchedulingDateRange(range)
  Scheduling::SchedulingDateRange.new(range.begin, range.end, range.exclude_end?)
end
