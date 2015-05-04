class EventsController < ApplicationController

def index
    render json: User.first.events
end

end
