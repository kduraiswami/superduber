require 'twilio-ruby'

class UsersController < ApplicationController

  def index
    render json: User.all
  end

  def show
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
    when "no_drivers_available" #need to testubu
      p message = "No drivers are available"
      event.send_twilio_message(message)
    when "rider_canceled"
      p message = "Your request has been cancelled"
      event.send_twilio_message(message)
    end

    render json: { message: message }
  end

  def cancel_ride # Webhook triggered by user SMS to Twilio
    user_response = params[:Body]
    user = User.find_by(phone: params[:From])

    if user_response == 'Abort' #decide on what this should be
      p event = user.next_event
      event.cancel_ride
    end

    render json: { message: "success" }
  end


end
