class EventsController < ApplicationController

  def index
    if current_user.nil?
      #render something that tells Angular to show the "Login via Uber" page
      redirect_to "/"
    else
      render json: {user: current_user, events: current_user.events}
      # render json: current_user.events
    end
    puts "CURRENT USER: **************************"
    p current_user
  end

  def create
    #this has to come from Angular controller
    user = User.find_or_create_by(uuid: params[:user_id])
    user.events.create(event_params)
    render json: user #nothing to render back
  end

  def destroy
    event = current_user.events.find_by(_id: params[:id])
    event.delete
    render json: {deleted_event: event}
  end

  def ubertest
    event = current_user.events.first
    event.update_estimate!
    render json: event
  end

  private

  def event_params
    params.require(:event).permit(:name, :depart_address, :arrival_address, :arrival_datetime)
  end

end
