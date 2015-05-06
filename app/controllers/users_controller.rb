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

  def request_uber # Webhook triggered by user SMS to Twilio
    puts "*************************"
    puts "SMS response from user:"
    puts params.inspect
    user_response = params[:Body]
    # user = User.find_by(phone: params[:From])
    # event = user.next_event # write this method
    # if user_response == event.surge_multiplier
      #request ride
    # else
      #return sms saying price has changed
    # end

    render json: {}
  end

  def uber_status_update # Webhook triggered by change in status of a ride request
    puts "*************************"
    puts "Status update from Uber:"
    puts params.inspect


  end


end
