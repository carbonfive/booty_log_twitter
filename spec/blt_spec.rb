require File.dirname(__FILE__) + '/spec_helper'

describe "My App" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  it "should respond to /favicon" do
    get '/favicon'
    last_response.should be_ok
  end
end