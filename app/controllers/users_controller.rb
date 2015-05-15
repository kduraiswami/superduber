require 'twilio-ruby'

class UsersController < ApplicationController

  def index

  end

  def show
    render json: current_user
  end

  def edit
  end

  def reset_session
    session.clear
    p "CLEARED SESSION!"
    redirect_to root_path
  end

  ### TWILIO ###
  # include WebhookableConcern
  # after_filter :set_header
  skip_before_action :verify_authenticity_token

  def uber_status_update # Webhook triggered by change in status of a ride request
    event = Event.find_by(ride_request_id: params["meta"]["resource_id"])

    puts "*************************"
    puts "Status update from Uber:"

    # if params["event_type"] == "requests.status_changed"
    # the other case is if it == "requests.receipt_ready"
    case params["meta"]["status"]
    when "processing"
      p "Request is processing"
    when "accepted"
      ride_info = event.check_ride_status
      name = ride_info["driver"]["name"]
      eta = ride_info["eta"]
      make = ride_info["vehicle"]["make"]
      model = ride_info["vehicle"]["model"]
      plate = ride_info["vehicle"]["license_plate"]

      p message = "#{name} will be arriving in #{eta} mins in a #{make} #{model} (Plate# #{plate}). Reply 'Abort' to cancel ride request."
      event.send_twilio_message(message)
    when "no_drivers_available"
      p message = "Sorry, no drivers are available at this time."
      event.send_twilio_message(message)
    when "driver_canceled"
      p message = "Sorry, your driver has canceled the trip."
    when "rider_canceled"
      p message = "Your request has been canceled."
      event.send_twilio_message(message)
    end

    render json: { message: message }
  end

  def cancel_ride # Webhook triggered by user SMS to Twilio
    user_response = params[:Body]
    user = User.find_by(phone: params[:From])
    event = user.next_event

    if user_response.downcase == 'abort' #decide on what this should be
      event.cancel_ride
      event.send_twilio_message('Canceling your ride request...')
    else
      event.send_twilio_message("Sorry, I didn't understand that. Please reply 'abort' to cancel a ride request, or log into your account for more information.")
    end

    render json: { message: "success" }
  end


end
