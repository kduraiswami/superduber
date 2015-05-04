class Event
  include Mongoid::Document
  field :name, type: String
  field :depart_address, type: String
  field :depart_lon, type: String
  field :depart_lat, type: String
  field :arrival_address, type: String
  field :arrival_lon, type: String
  field :arrival_lat, type: String
  field :arrival_datetime, type: Time
  field :ride_id, type: String
  field :ride_name, type: String
  field :duration_estimate, type: Integer
  field :pickup_estimate, type: Integer

  embedded_in :user, inverse_of: :events

  def estimated_duration
    self.duration_estimate + self.pickup_estimate
  end

  def estimated_duration_minutes
    (estimated_duration / 60.0).ceil
  end

end
