class EventsController < ApplicationController
  before_filter :authenticate_user!

  def home
    date_time = DateTime.now
    Event.my_events = false
    Event.current_user = nil
    make_calendar(date_time)

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

    make_calendar(date_time)

    Event.selected_date = nil

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

    make_calendar(date_time)

    Event.selected_date = nil

    render :partial => 'shared/calendar'
  end

  def index
    day = params[:day]
    month = params[:month]
    year = params[:year]

    Event.selected_date = DateTime.new(year.to_i, month.to_i, day.to_i)

    make_events()

    render :partial => 'shared/events'
  end

  def create
    @success_message = "created"

    @event = Event.new
    @event.name = params[:event][:name]
    date_event = DateTime.new(params[:event]['date_event(1i)'].to_i,
                                     params[:event]['date_event(2i)'].to_i,
                                     params[:event]['date_event(3i)'].to_i)
    @event.date_event = date_event
    @event.user = current_user
    @event.repeat = params[:event][:repeat]
    @success = @event.save

    Event.selected_date = DateTime.new(year.to_i, month.to_i, day.to_i)

    make_events()

    make_calendar(date_event)

    respond_to do |format|
      format.js
    end
  end

  def update
    @success_message = "updated"
    id = params[:id]
    @event = Event.find(id)
    @event.name = params[:event][:name]
    date_event = DateTime.new(params[:event]['date_event(1i)'].to_i,
                                     params[:event]['date_event(2i)'].to_i,
                                     params[:event]['date_event(3i)'].to_i)
    @event.date_event = date_event
    @event.repeat= params[:event][:repeat]
    @success = @event.save

    make_events()

    make_calendar(date_event)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    id = params[:id]
    @event = Event.find(id)
    @event.delete

    make_events()

    make_calendar(Event.selected_date)

    respond_to do |format|
      format.js
    end
  end

  def my_events
    if Event.selected_date.nil?
      @day = '1'
      month = params[:month]
      year = params[:year]
      date_time = DateTime.new(year.to_i, month.to_i, @day.to_i)
    else
      @day = params[:selected_day_event]
      date_time = Event.selected_date
    end

    Event.my_events = true
    Event.current_user = current_user

    make_calendar(date_time)

    make_events()

    render :partial => 'shared/calendar-events'
  end

  def all_events
    if Event.selected_date.nil?
      @day = '1'
      month = params[:month]
      year = params[:year]
      date_time = DateTime.new(year.to_i, month.to_i, @day.to_i)
    else
      @day = params[:selected_day_event]
      date_time = Event.selected_date
    end

    Event.my_events = false
    Event.current_user = nil

    make_calendar(date_time)

    make_events()

    render :partial => 'shared/calendar-events'
  end

  private

  def make_calendar(date_time)
    Event.make_calendar(date_time)
    @month = Event.month
    @year = Event.year
    @days_in_calendar_before = Event.days_in_calendar_before
    @calendar_days = Event.calendar_days
    @days_in_calendar = Event.days_in_calendar
    @calendar_days_styles = Event.calendar_days_styles
  end

  def make_events
    Event.make_events
    @day = Event.day
    @date = Event.date
    @events = Event.events
  end
end
