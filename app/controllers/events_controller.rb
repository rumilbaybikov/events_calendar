class EventsController < ApplicationController
  def index
    day = params[:day]
    month = params[:month]
    y = params[:year]
    d = day.size == 1 ? '0' + day : day
    m = month.size == 1 ? '0' + month : month
    c_d = DateTime.new(y.to_i, month.to_i, day.to_i)
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
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
    @success_message = "udated"
    id = params[:id]
    @event = Event.find(id)
    @event.name = params[:event][:name]
    @event.date_event = DateTime.new(params[:event]['date_event(1i)'].to_i,
                                     params[:event]['date_event(2i)'].to_i,
                                     params[:event]['date_event(3i)'].to_i)
    @event.repeat= params[:event][:repeat]
    @success = @event.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
  end
end
