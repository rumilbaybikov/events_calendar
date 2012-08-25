class CalendarsController < ApplicationController
  require 'date'

  def show
    date_time = DateTime.now
    @year = date_time.year
    @month = date_time.month
    first_day_of_month = date_time.at_beginning_of_month
    last_day_of_month = date_time.at_end_of_month
    day_of_week = first_day_of_month.wday
    @days_in_calendar_before = 0
    if day_of_week == 0
      @days_in_calendar_before = 6
    else
      @days_in_calendar_before = day_of_week - 1
    end
    @days_in_calendar = @days_in_calendar_before + last_day_of_month.day
    @days_in_calendar_after = 7 -(@days_in_calendar - (@days_in_calendar/7)*7)

    @days_in_calendar_overall = @days_in_calendar + @days_in_calendar_after

    @calendar_days = Array.new(@days_in_calendar_overall)

    i = @days_in_calendar_before
    count = 0
    while i > 0 do
      count += 1
      i -= 1
      @calendar_days[i] = (first_day_of_month - count).day
    end

    i = 1
    while i <= last_day_of_month.day do
      @calendar_days[i + @days_in_calendar_before -1] = i
      i += 1
    end

    i = 0
    while i < @days_in_calendar_after do
      i += 1
      @calendar_days[@days_in_calendar_before + last_day_of_month.day - 1 + i] = (last_day_of_month + i).day
    end

    @event = Event.new

    i = @days_in_calendar_before
    @calendar_days_styles = Array.new(@days_in_calendar_overall)
    month = @month.to_s
    count = 0
    while count < last_day_of_month.day do
      count += 1
      event_count = Event.where("strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?",
                                       (count).to_s.size == 1 ? '0' + (count).to_s : (count).to_s,
                                       month.size == 1 ? '0' + month : month,
                                       @year.to_s).count()
      if event_count > 0
        @calendar_days_styles[i] = 'date_has_event'
      else
        @calendar_days_styles[i] = 'none'
      end
      i += 1
    end
  end
end
