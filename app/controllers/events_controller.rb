class EventsController < ApplicationController

  def ubertest
    event = current_user.events.first
    update_estimate!(event)
    render json: event
  end

end
