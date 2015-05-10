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
        end_latitude: event.arrival_lat,
        end_longitude: event.arrival_lon
      }.to_json
    )
  end

end

