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
    puts "*************************"
    puts "Status update from Uber:"
    puts params.inspect

    render json: params

    #Find event based on info in webhook response
    #Send twilio notification (case statement based on the status received from Uber)

  end

  def cancel_ride # Webhook triggered by user SMS to Twilio

    #Find the event based on phone number
    #event.cancel_ride to trigger delete request
    #Send success message to user if receive status 204 from Uber

    user_response = params[:Body]
    p user = User.find_by(phone: params[:From])
    p event = user.next_event
    event.cancel_ride
    # if user_response == "666"
      #request ride
    # else
      #return sms saying price has changed
    # end

    render json: {}
  end


end
