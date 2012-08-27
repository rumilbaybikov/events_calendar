class CalendarsController < ApplicationController
  def about

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

  def my_events
    if params[:selected_day_event].blank?
      @day = '1'
    else
      @day = params[:selected_day_event]
    end
    month = params[:month]
    year = params[:year]
    current_user_id = params[:current_user_id]
    EventsController.curr_user= current_user_id
    EventsController.my_events=true
    date_time = DateTime.new(year.to_i, month.to_i, @day.to_i)
    Event.make_calendar(date_time)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    @event = Event.new

    unless params[:selected_day_event].blank?
      d = @day.size == 1 ? '0' + @day : @day
      m = month.size == 1 ? '0' + month : month
      c_d = date_time
      @@selected_date = c_d
      w = c_d.wday.to_s
      y = year
      current_user_events_opt = 'user_id = ' + current_user_id
      @events = Event.where("(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                            "(repeat = 1 AND date_event < ?) OR " +
                            "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                            "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                            "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)",
                            d, m, y, c_d, w, c_d, d, c_d, d, m, c_d).where(current_user_events_opt)

      @date = d + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y
    end

    render :partial => 'shared/calendar-events'
  end

  def all_events
    if params[:selected_day_event].blank?
      @day = '1'
    else
      @day = params[:selected_day_event]
    end
    month = params[:month]
    year = params[:year]
    EventsController.my_events=false
    date_time = DateTime.new(year.to_i, month.to_i, @day.to_i)
    Event.make_calendar(date_time)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    @event = Event.new

    unless params[:selected_day_event].blank?
      d = @day.size == 1 ? '0' + @day : @day
      m = month.size == 1 ? '0' + month : month
      c_d = date_time
      @@selected_date = c_d
      w = c_d.wday.to_s
      y = year

      @events = Event.where("(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                            "(repeat = 1 AND date_event < ?) OR " +
                            "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                            "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                            "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)",
                            d, m, y, c_d, w, c_d, d, c_d, d, m, c_d)

      @date = d + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y
    end

    render :partial => 'shared/calendar-events'
  end
end
