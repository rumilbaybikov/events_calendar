require "test/unit"

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_fail
    eventsCalendar = EventsControllerTest.new
    assert_equal(eventsCalendar.testCalendar(), '33', "test days in calendar")
  end
end

class EventsControllerTest
  def testCalendar
    first_day_of_month = Time.new.at_beginning_of_month
    last_day_of_month = Time.now.at_end_of_month
    day_of_week = first_day_of_month.day
    days_in_calendar = 0
    if day_of_week == 0
      days_in_calendar = last_day_of_month + 6
    else
      days_in_calendar = last_day_of_month + day_of_week - 1
    end
    days_in_calendar
  end
end