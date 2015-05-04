class EventsController < ApplicationController

  def ubertest
    event = current_user.events.first



    render json: event
  end

end
