class HomeController < ApplicationController
  def index
    render "layouts/application"
  end

  def request_uber # Triggered when user clicks link to accept ride (or if surging, after they accept surge pricing, Uber redirects here)
    if params[:surge_confirmation_id]
      event = Event.find_by(surge_confirmation_id: params[:surge_confirmation_id])
    else
      event = Event.find(params[:event_id])
    end

    response = event.request_ride


    render json: response # Placeholder action; likely need to redirect to new view page that shows the ride has been requested, has a button to cancel, etc.  Ideally this page would then refresh automatically as soon as the ride has been accepted by uber, and show the ride info.  Should this all be on '/' route?

  end
end
