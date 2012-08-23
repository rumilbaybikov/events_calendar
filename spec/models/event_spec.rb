require 'spec_helper'

describe Event do
  it "should require a name" do
    no_name_user = Event.new(:name => "")
    no_name_user.should_not be_valid
  end
end
