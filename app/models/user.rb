class User
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :phone, type: String
  # field :validated, type: Mongoid::Boolean
  field :uber_access_token, type: String
  field :uber_refresh_token, type: String
  field :picture, type: String
  field :uuid, type: String

  has_many :events

end
