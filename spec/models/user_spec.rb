require 'spec_helper'

describe User do
  it "should require an email address" do
    no_email_user = User.new(:email => "")
    no_email_user.should_not be_valid
  end
end