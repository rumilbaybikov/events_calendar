class Event < ActiveRecord::Base
  attr_accessible :date_event, :name

  validates :name, :presence => true
end
