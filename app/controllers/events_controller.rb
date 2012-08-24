class EventsController < ApplicationController
  require 'date'
  
  def index
    first_day_of_month = DateTime.now.at_beginning_of_month
    last_day_of_month = DateTime.now.at_end_of_month
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
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
