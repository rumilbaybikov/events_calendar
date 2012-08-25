class EventsController < ApplicationController
  def index
    day = params[:day]
    month = params[:month]
    year = params[:year]
    date_time = DateTime.new(year.to_i, month.to_i, day.to_i)
    @events = Event.where("strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?",
                          day.size == 1 ? '0' + day : day,
                          month.size == 1 ? '0' + month : month,
                          year)
    @date = day + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + year
    render :partial => 'shared/events'
  end

  def show
  end

  def create
    @event = Event.new
    @event.name = params[:event][:name]
    @event.date_event = DateTime.new(params[:event]['date_event(1i)'].to_i,
                                     params[:event]['date_event(2i)'].to_i,
                                     params[:event]['date_event(3i)'].to_i)
    @success = @event.save
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
