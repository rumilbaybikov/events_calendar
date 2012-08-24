class Event < ActiveRecord::Base
  attr_accessible :name, :date_event

  validates :name, :presence => true
  validates :date_event, :presence => true
end
