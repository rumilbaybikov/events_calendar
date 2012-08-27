class EventsController < ApplicationController
  before_filter :authenticate_user!

  @@selected_date = nil
  @@my_events = false

  def home
    date_time = DateTime.now
    make_calendar(date_time)
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

    EventsController.selected_date=nil

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

    EventsController.selected_date=nil

    render :partial => 'shared/calendar'
  end

  def index
    @day = params[:day]
    month = params[:month]
    y = params[:year]
    d = @day.size == 1 ? '0' + @day : @day
    m = month.size == 1 ? '0' + month : month
    c_d = DateTime.new(y.to_i, month.to_i, @day.to_i)
    @@selected_date = c_d
    w = c_d.wday.to_s
    current_user_events_opt = ''
    if @@my_events
      current_user_events_opt = 'user_id = ' + current_user.id.to_s
    end
    @events = Event.where("(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                          "(repeat = 1 AND date_event < ?) OR " +
                          "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                          "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                          "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)",
                          d, m, y, c_d, w, c_d, d, c_d, d, m, c_d).where(current_user_events_opt)

    @date = @day + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y
    render :partial => 'shared/events'
  end

  def create
    @success_message = "created"
    @event.name = params[:event][:name]
    @event.date_event = DateTime.new(params[:event]['date_event(1i)'].to_i,
                                     params[:event]['date_event(2i)'].to_i,
                                     params[:event]['date_event(3i)'].to_i)
    @event.user =current_user
    @event.repeat = params[:event][:repeat]
    @success = @event.save

    make_events()

    if @@selected_date.nil?
      make_calendar(DateTime.now)
    else
      make_calendar(@@selected_date)
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @success_message = "updated"
    id = params[:id]
    @event = Event.find(id)
    @event.name = params[:event][:name]
    @event.date_event = DateTime.new(params[:event]['date_event(1i)'].to_i,
                                     params[:event]['date_event(2i)'].to_i,
                                     params[:event]['date_event(3i)'].to_i)
    @event.repeat= params[:event][:repeat]
    @success = @event.save

    make_events()

    make_calendar(@@selected_date)

    respond_to do |format|
      format.js
    end
  end

  def my_events
    if @@selected_date.nil?
      @day = '1'
      month = params[:month]
      year = params[:year]
      date_time = DateTime.new(year.to_i, month.to_i, @day.to_i)
    else
      @day = params[:selected_day_event]
      date_time = @@selected_date
    end

    EventsController.my_events =true

    make_calendar(date_time)

    make_events()

    render :partial => 'shared/calendar-events'
  end

  def all_events
    if @@selected_date.nil?
      @day = '1'
      month = params[:month]
      year = params[:year]
      date_time = DateTime.new(year.to_i, month.to_i, @day.to_i)
    else
      @day = params[:selected_day_event]
      date_time = @@selected_date
    end

    EventsController.my_events=false

    make_calendar(date_time)

    make_events()

    render :partial => 'shared/calendar-events'
  end

  def self.selected_date=(date)
    @@selected_date=date
  end

  def self.my_events
    @@my_events
  end

  def self.my_events=(bool)
    @@my_events=bool
  end

  private

  def make_calendar(date_time)
    Event.make_calendar(date_time)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    @event = Event.new
  end

  def make_events
    if @@selected_date.nil?
      @date = nil
    else
      c_d = @@selected_date
      @day = c_d.day.to_s
      d = day.size == 1 ? '0' + day : day
      w = c_d.wday.to_s
      month = c_d.month.to_s
      m = month.size == 1 ? '0' + month : month
      y = c_d.year.to_s

      if @@my_events
        current_user_events_opt = 'user_id = ' + current_user.id.to_s
      end

      @events = Event.where("(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                            "(repeat = 1 AND date_event < ?) OR " +
                            "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                            "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                            "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)",
                            d, m, y, c_d, w, c_d, d, c_d, d, m, c_d).where(current_user_events_opt)

      @date = day + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y
    end
  end
end
