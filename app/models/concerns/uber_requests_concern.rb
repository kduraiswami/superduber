module UberRequestsConcern
  extend ActiveSupport::Concern

  def request_estimate_response(event)
    HTTParty.post("https://sandbox-api.uber.com/v1/requests/estimate",
      headers: {"Authorization" => "Bearer #{event.user.uber_access_token}",
      "scope" => "request",
      "Content-Type" => "application/json",
      },
      body: {
        product_id: event.ride_id,
        start_latitude: event.depart_lat,
        start_longitude: event.depart_lon,
        # start_latitude: "37.7863918",
        # start_longitude: "-122.4535854",
        end_latitude: event.arrival_lat,
        end_longitude: event.arrival_lon
      }.to_json
    )
  end

end


# HTTParty.put("https://sandbox-api.uber.com/v1/sandbox/requests/a8d4b278-adaf-47b8-87ab-958c6e429580",
#       headers: {"Authorization" => "Bearer #{e.user.uber_access_token}",
#       "scope" => "request",
#       "Content-Type" => "application/json",
#       },
#       body: {
#         status: 'accepted'
#       }.to_json)