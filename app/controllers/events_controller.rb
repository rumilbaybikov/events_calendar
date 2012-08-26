class EventsController < ApplicationController
  @@selected_date = nil

  def index
    day = params[:day]
    month = params[:month]
    y = params[:year]
    d = day.size == 1 ? '0' + day : day
    m = month.size == 1 ? '0' + month : month
    c_d = DateTime.new(y.to_i, month.to_i, day.to_i)
    @@selected_date = c_d
    w = c_d.wday.to_s
    @events = Event.where("(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                              "(repeat = 1 AND date_event < ?) OR " +
                              "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                              "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                              "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)",
                          d, m, y, c_d, w, c_d, d, c_d, d, m, c_d)

    @date = day + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y
    render :partial => 'shared/events'
  end

  def show
  end

  def create
    @success_message = "created"
    @event= Event.new
    @event.name= params[:event][:name]
    @event.date_event= DateTime.new(params[:event]['date_event(1i)'].to_i,
                                     params[:event]['date_event(2i)'].to_i,
                                     params[:event]['date_event(3i)'].to_i)
    @event.repeat= params[:event][:repeat]
    @success = @event.save

    c_d = @@selected_date
    unless c_d.nil?
      day = c_d.day.to_s
      d = day.size == 1 ? '0' + day : day
      w = c_d.wday.to_s
      month = c_d.month.to_s
      m = month.size == 1 ? '0' + month : month
      y = c_d.year.to_s

      @events = Event.where("(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                                "(repeat = 1 AND date_event < ?) OR " +
                                "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                                "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                                "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)",
                            d, m, y, c_d, w, c_d, d, c_d, d, m, c_d)

      @date = day + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y
    end

    if c_d.nil?
      c_d = DateTime.now
      @date = nil
    end

    Event.make_calendar(c_d)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    respond_to do |format|
      format.js
    end
  end

  def edit
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

    c_d = @@selected_date
    day = c_d.day.to_s
    d = day.size == 1 ? '0' + day : day
    w = c_d.wday.to_s
    month = c_d.month.to_s
    m = month.size == 1 ? '0' + month : month
    y = c_d.year.to_s

    @events = Event.where("(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                              "(repeat = 1 AND date_event < ?) OR " +
                              "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                              "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                              "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)",
                          d, m, y, c_d, w, c_d, d, c_d, d, m, c_d)

    Event.make_calendar(c_d)
    @month= Event.month
    @year= Event.year
    @days_in_calendar_before= Event.days_in_calendar_before
    @calendar_days= Event.calendar_days
    @days_in_calendar= Event.days_in_calendar
    @calendar_days_styles= Event.calendar_days_styles

    @date = day + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y

    respond_to do |format|
      format.js
    end
  end

  def destroy
  end

  def self.selected_date=(date)
    @@selected_date=date
  end
end
