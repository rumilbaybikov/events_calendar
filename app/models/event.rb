class Event < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :date_event

  validates :name, :presence => true, :length => { :within => 3 .. 17 }
  validates :date_event, :presence => true

  @@selected_date = nil
  @@my_events = false
  @@current_user = nil
  @@day = nil
  @@date = nil
  @@events = nil

  # sqlite
  @@event_query = "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND strftime('%Y', date_event) = ?) OR " +
                  "(repeat = 1 AND date_event < ?) OR " +
                  "(strftime('%w', date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
                  "(strftime('%d', date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
                  "(strftime('%d', date_event) = ? AND strftime('%m', date_event) = ? AND repeat = 4 AND date_event < ?)"

  # postgres
  #@@event_query = "(extract(day from date_event) = ? AND extract(month from date_event) = ? AND extract(year from date_event) = ?) OR " +
  #                "(repeat = 1 AND date_event < ?) OR " +
  #                "(extract(week from date_event) = ? AND repeat = 2 AND date_event < ?) OR" +
  #                "(extract(day from date_event) = ? AND repeat = 3 AND date_event < ?) OR" +
  #                "(extract(day from date_event) = ? AND extract(month from date_event) = ? AND repeat = 4 AND date_event < ?)"

  def self.make_calendar(date_time)
    @@day = date_time.day
    @@year = date_time.year
    @@month = date_time.month
    first_day_of_month = date_time.at_beginning_of_month
    last_day_of_month = date_time.at_end_of_month
    day_of_week = first_day_of_month.wday
    @@days_in_calendar_before = 0
    if day_of_week == 0
      @@days_in_calendar_before = 6
    else
      @@days_in_calendar_before = day_of_week - 1
    end
    @@days_in_calendar = @@days_in_calendar_before + last_day_of_month.day
    @@days_in_calendar_after = 7 -(@@days_in_calendar - (@@days_in_calendar / 7) * 7)

    @@days_in_calendar_overall = @@days_in_calendar + @@days_in_calendar_after

    @@calendar_days = Array.new(@@days_in_calendar_overall)

    i = @@days_in_calendar_before
    count = 0
    while i > 0 do
      count += 1
      i -= 1
      @@calendar_days[i] = (first_day_of_month - count).day
    end

    i = 1
    while i <= last_day_of_month.day do
      @@calendar_days[i + @@days_in_calendar_before -1] = i
      i += 1
    end

    i = 0
    while i < @@days_in_calendar_after do
      i += 1
      @@calendar_days[@@days_in_calendar_before + last_day_of_month.day - 1 + i] = (last_day_of_month + i).day
    end

    i = @@days_in_calendar_before
    @@calendar_days_styles = Array.new(@@days_in_calendar_overall)
    month = @@month.to_s
    count = 0

    now = DateTime.now

    current_month = false
    if @@month == now.month && @@year == now.year
      current_month = true
    end

    current_user_events_opt = ''
    if Event.my_events
      current_user_events_opt = 'user_id = ' + @@current_user.id.to_s
    end

    while count < last_day_of_month.day do
      count += 1
      if current_month && count == now.day
        @@calendar_days_styles[i] = 'today'
      else
        d =(count).to_s.size == 1 ? '0' + (count).to_s : (count).to_s
        m = month.size == 1 ? '0' + month : month
        y = @@year.to_s
        c_d = DateTime.new(y.to_i, m.to_i, d.to_i)
        w = c_d.wday.to_s
        event_count = where(@@event_query,
                            d, m, y, c_d, w, c_d, d, c_d, d, m, c_d).where(current_user_events_opt).count()
        if event_count > 0
          @@calendar_days_styles[i] = 'date_has_event'
        else
          @@calendar_days_styles[i] = 'none'
        end
      end
      i += 1
    end
  end

  def self.month
    @@month
  end

  def self.year
    @@year
  end

  def self.days_in_calendar_before
    @@days_in_calendar_before
  end

  def self.calendar_days
    @@calendar_days
  end

  def self.calendar_days_styles
    @@calendar_days_styles
  end

  def self.days_in_calendar
    @@days_in_calendar
  end

  def self.selected_date
    @@selected_date
  end

  def self.selected_date=(date)
    @@selected_date=date
  end

  def self.current_user=(user)
    @@current_user = user
  end

  def self.my_events
    @@my_events
  end

  def self.my_events=(bool)
    @@my_events=bool
  end

  def self.day
    @@day
  end

  def self.events
    @@events
  end

  def self.date
    @@date
  end

  def self.make_events
    if @@selected_date.nil?
      @date = nil
    else
      c_d = @@selected_date
      @@day = c_d.day.to_s
      d = day.size == 1 ? '0' + day : day
      w = c_d.wday.to_s
      month = c_d.month.to_s
      m = month.size == 1 ? '0' + month : month
      y = c_d.year.to_s

      if @@my_events
        current_user_events_opt = 'user_id = ' + @@current_user.id.to_s
      end

      @@events = Event.where(@@event_query,
                             d, m, y, c_d, w, c_d, d, c_d, d, m, c_d).where(current_user_events_opt)

      @@date = day + ' ' + Date::MONTHNAMES[month.to_i] + ' ' + y
    end
  end
end
