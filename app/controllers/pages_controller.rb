class PagesController < ApplicationController
  require 'date'

  def home
    date_time = DateTime.now
    Event.make_calendar(date_time)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    @event = Event.new
  end

  def dec_month
    month = params[:month].to_i - 1
    year = params[:year].to_i
    if (month == 0)
      month = 12
      year -= 1
    end
    date_time = DateTime.new(year.to_i, month, 1)
    Event.make_calendar(date_time)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    EventsController.selected_date=nil

    @event = Event.new

    render :partial => 'shared/calendar'
  end

  def inc_month
    month = params[:month].to_i + 1
    year = params[:year].to_i
    if (month == 13)
      month = 1
      year += 1
    end
    date_time = DateTime.new(year, month, 1)
    Event.make_calendar(date_time)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    EventsController.selected_date=nil

    @event = Event.new

    render :partial => 'shared/calendar'
  end
end
