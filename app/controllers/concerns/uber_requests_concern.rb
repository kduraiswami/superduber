module UberRequestsConcern
  extend ActiveSupport::Concern

  def update_estimate!(event)

    response = HTTParty.post("https://api.uber.com/v1/requests/estimate",
      headers: {"Authorization" => "Bearer #{current_user.uber_access_token}",
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

    event.pickup_estimate = response['pickup_estimate']*60
    event.duration_estimate = response['trip']['duration_estimate']
    event.save!

  end

end