class EventsController < ApplicationController

def index
    render json: User.first.events
end

def ubertest
  event = current_user.events.first
  render json: event
end

end
