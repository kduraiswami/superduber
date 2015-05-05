class EventsController < ApplicationController

  def index
      render json: User.first.events
  end

  def ubertest
    event = current_user.events.first
    event.update_estimate!
    render json: event
  end

end
