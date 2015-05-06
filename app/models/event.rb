class Event
  include UberRequestsConcern
  include Mongoid::Document
  field :name, type: String
  field :depart_address, type: String
  field :depart_lon, type: String
  field :depart_lat, type: String
  field :arrival_address, type: String
  field :arrival_lon, type: String
  field :arrival_lat, type: String
  field :arrival_datetime, type: Time #UTC OR LOCAL TIME?
  field :ride_id, type: String # Product code
  field :ride_name, type: String #e.g. UberX
  field :ride_request_id, type: String #ID for the request
  field :surge_confirmation_id, type: String
  field :duration_estimate, type: Integer
  field :pickup_estimate, type: Integer

  belongs_to :user

  def time_as_str
    self.arrival_datetime.strftime("%l:%M%P")
  end

  def estimated_duration
    self.duration_estimate + self.pickup_estimate
  end

  def update_estimate!
    puts "RIDE ESTIMATE RESPONSE:"
    p response = request_estimate_response(self)

    self.pickup_estimate = response['pickup_estimate']
    self.duration_estimate = (response['trip']['duration_estimate']/60.0).ceil
    self.save!

    puts "ESTIMATED DURATION: #{estimated_duration} (minutes)"

    response
  end

  def notification_buffer
    return 10.minutes
  end

  def time_to_notify_user
    self.arrival_datetime - estimated_duration - notification_buffer
  end

  def schedule_bg_job
    update_estimate!
    time = time_of_next_bg_job

    if time_to_notify_user < time
      Resque.enqueue(NotifyUserWorker, self)
      puts "time to notify user is < time of next bg job; run NotifyUserWorker"
    elsif time_to_notify_user - time < notification_buffer
      Resque.enqueue_at(time_to_notify_user, NotifyUserWorker, self)
      puts "time to notify user minus time of next bg job is < 10min; schedule NotifyUserWorker"
    else
      Resque.enqueue_at(time, RequestEstimateWorker, self)
      puts "time to notify user is > 10min so schedule another RequestEstimateWorker"
    end

    puts "************************************"
    puts "Scheduled background job:"
    puts "Time of event: #{self.arrival_datetime}"
    puts "Time to notify user: #{time_to_notify_user}"
    puts "Time of next background job: #{time}"
    puts "Current time: #{Time.current}"
    puts "************************************"
  end

  def time_of_next_bg_job
    if time_to_notify_user - Time.now > 180.minutes #more than 3 hours before need to notify
      return time_to_notify_user - 180.minutes
    else
      return time_to_notify_user - ((time_to_notify_user - Time.now) / 2)
    end
  end

  def request_ride
    response = HTTParty.post("https://sandbox-api.uber.com/v1/requests",
      headers: {"Authorization" => "Bearer #{self.user.uber_access_token}",
      "scope" => "request",
      "Content-Type" => "application/json",
      },
      body: {
        product_id: self.ride_id,
        start_latitude: self.depart_lat,
        start_longitude: self.depart_lon,
        # start_latitude: "37.7863918",
        # start_longitude: "-122.4535854",
        end_latitude: self.arrival_lat,
        end_longitude: self.arrival_lon
      }.to_json
    )

    self.ride_request_id = response["request_id"]
    self.save!

    response
  end

  def change_ride_status(status) #For sandbox / testing only
    response = HTTParty.put("https://sandbox-api.uber.com/v1/sandbox/requests/#{self.ride_request_id}",
      headers: {"Authorization" => "Bearer #{self.user.uber_access_token}",
        "scope" => "request",
        "Content-Type" => "application/json",
      },
      body: {
          status: status #either use 'accepted' or 'no_drivers_available'
      }.to_json
    )

    puts response
  end

  ### TWILIO NOTIFICATION ###
  def send_twilio_notification #Initial notification asking user if they want to request a ride
    response = update_estimate!
    cost_range = response['price']['display']
    surge_multiplier = response['price']['surge_multiplier']
    self.surge_confirmation_id = response['price']['surge_confirmation_id']
    surge_confirmation_href = response['price']['surge_confirmation_href']

    url = (surge_confirmation_href ? surge_confirmation_href : "#{Rails.env.development? ? "http://1cac61d0.ngrok.com" : root_url}/request_uber")

    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = client.messages.create(
      :from => '+19255237514',
      :to => '+15182813326',
      :body => "Upcoming event '#{self.name}' at#{self.time_as_str}. #{self.ride_name} estimated cost: #{cost_range}; pickup time: #{self.pickup_estimate}min; ride duration: #{self.duration_estimate}min. Surge multiplier: #{surge_multiplier}. Click to confirm: #{url}",
      # :media_url => 'http://linode.rabasa.com/yoda.gif'
      # status_callback: request.base_url + '/twilio/status'
      )
  end


end

    # HTTParty.put("https://api.uber.com/v1/sandbox/requests/f61977d2-fa16-4587-9d24-a088df96a22f",
    #   headers: {"Authorization" => "Bearer #{e.user.uber_access_token}",
    #     "scope" => "request",
    #     "Content-Type" => "application/json",
    #   },
    #   body: {
    #       status: 'accepted' #either use 'accepted' or 'no_drivers_available'
    #   }.to_json
    # )