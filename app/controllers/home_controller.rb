class HomeController < ApplicationController
  def index
    if current_user #if user is logged in
      if current_user.phone #if they already have phone saved in DB
        events = current_user.upcoming_sorted_events
        @event = Event.new
        render "users/index", locals: {events: events, current_user: current_user}
        puts "CURRENT USER: #{current_user}"
      else #if they are logged in but don't have phone saved
        render edit_user_path(current_user.uuid), locals: {current_user: current_user}
      end
    else #user is not logged in so render logged out landing page
      #render logged out ERB page
    end
  end

  def request_uber # Triggered when user clicks link to accept ride (or if surging, after they accept surge pricing, Uber redirects here)
    if params[:surge_confirmation_id]
      event = Event.find_by(surge_confirmation_id: params[:surge_confirmation_id])
    else
      event = Event.find(params[:event_id])
    end

    response = event.request_ride

    render "home/request_uber", locals: {event: event}
  end
end
