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
        start_latitude: event.depart_coords[0],
        start_longitude: event.depart_coords[1],
        end_latitude: event.arrival_coords[0],
        end_longitude: event.arrival_coords[1]
      }.to_json
    )
  end

end

