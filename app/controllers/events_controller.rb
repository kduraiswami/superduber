class EventsController < ApplicationController

  def index
    if current_user.nil?
      #render something that tells Angular to show the "Login via Uber" page
      # redirect_to "/"
    else
      render json: {user: current_user, events: current_user.events}
      # render json: current_user.events
    end
    puts "CURRENT USER: **************************"
    p current_user
  end

  def create
    #this has to come from Angular controller
    puts "INSIDE EVENT CREATE ROUTE!"
    p params.inspect
  end

  def ubertest
    event = current_user.events.first
    event.update_estimate!
    render json: event
  end

end
