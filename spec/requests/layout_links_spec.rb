require 'spec_helper'

describe "LayoutLinks" do
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  it "should have a Sign in page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Sign in")
  end
end
