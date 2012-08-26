class PagesController < ApplicationController
  before_filter :authenticate_user!

  require 'date'

  def about

  end

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
end
