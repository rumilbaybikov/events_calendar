class EventsController < ApplicationController
  def index

  end

  def show
  end

  def new
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
