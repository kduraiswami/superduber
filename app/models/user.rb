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

  def upcoming_sorted_events #This is what's shown to the user
    self.events.select {|e| e.arrival_datetime.future?}.sort_by{|e| e.arrival_datetime}
  end

  def next_event #Used in Twilio webhook to return the upcoming event
    self.upcoming_sorted_events.first
  end

end
