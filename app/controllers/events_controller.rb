class EventsController < ApplicationController

  def index
    if current_user.nil?
      redirect_to "/"
    else
      render json: {user: current_user, events: current_user.upcoming_sorted_events}
    end
    puts "CURRENT USER: **************************"
    p current_user
  end

  def edit
    @user = User.find_by(uuid: params[:user_id])
    @event = @user.events.find_by(id: params[:id])
  end

  def create
    user = User.find_by(uuid: params[:user_id])
    @event = user.events.new(event_params)
    if @event.save && @event.update_ride_id!
      @event.schedule_bg_job
      redirect_to "/?message=success#upcoming"
    else
      if @event.valid? #uber update_ride_id! failed
        @errors = ['Cannot find rides for departure address','Please make sure it is accurate']
        @event.destroy
      else
        @errors = @event.errors.full_messages
      end
      render "users/index", locals: {current_user: user}
    end
  end

  def update
    user = User.find_or_create_by(uuid: params[:user_id])
    event = user.events.find_by(id: params[:id])
    event.update_attributes(event_params)
    event.update_ride_id!
    redirect_to "/"
  end

  def destroy
    event = User.find_by(uuid: params[:user_id]).events.find_by(_id: params[:id])
    event.delete
    render json:{deleted_event: event}
  end

  def ubertest
    event = current_user.events.first
    event.update_estimate!
    render json: event
  end

  private

  def event_params
    params.require(:event).permit(:name, :depart_address, :arrival_address, :arrival_datetime, :ride_name)
  end

end
