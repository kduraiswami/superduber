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

  embedded_in :user, inverse_of: :events
end
