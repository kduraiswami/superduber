class User
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :phone, type: String #Must be format "+15556667777" for Twilio
  # field :validated, type: Mongoid::Boolean
  field :uber_access_token, type: String
  field :uber_refresh_token, type: String
  field :picture, type: String
  field :uuid, type: String

  has_many :events

  def next_event #Used in Twilio webhook to return the upcoming event
    self.events.select {|e| e.arrival_datetime > Time.now}.sort_by{|e| e.arrival_datetime}.first
  end

end
