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

      p message = "#{name} will be arriving in #{eta} mins in a #{make} #{model} (Plate# #{plate})."
      event.send_twilio_message(message)
    when "no_drivers_available" #need to test
      p message = "No drivers are available"
      event.send_twilio_message(message)
    when "rider_canceled"
      p message = "Your request has been cancelled"
      event.send_twilio_message(message)
    end

    render json: { message: message }
  end

  def cancel_ride # Webhook triggered by user SMS to Twilio

    #Find the event based on phone number
    #event.cancel_ride to trigger delete request
    #Send success message to user if receive status 204 from Uber

    user_response = params[:Body]
    user = User.find_by(phone: params[:From])
    event = user.next_event
    # if user_response == "666"
      #request ride
    # else
      #return sms saying price has changed
    # end

    render json: {}
  end


end
