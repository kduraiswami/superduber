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

  def update_estimate!
    puts "RIDE ESTIMATE RESPONSE:"
    p response = HTTParty.post("https://api.uber.com/v1/requests/estimate",
      # headers: {"Authorization" => "Bearer #{current_user.uber_access_token}",
      headers: {"Authorization" => "Bearer yhidsWd75ORVelqceWMGDvVqkrp8qC",
      "scope" => "request",
      "Content-Type" => "application/json",
      },
      body: {
        product_id: self.ride_id,
        start_latitude: self.depart_lat,
        start_longitude: self.depart_lon,
        end_latitude: self.arrival_lat,
        end_longitude: self.arrival_lon
      }.to_json
    )

    self.pickup_estimate = response['pickup_estimate']*60
    self.duration_estimate = response['trip']['duration_estimate']
    self.save!

    puts "ESTIMATED DURATION: #{estimated_duration_minutes} (minutes)"
  end

  def notification_buffer
    return 10.minutes
  end

  def time_to_notify_user
    self.arrival_datetime - estimated_duration_minutes - notification_buffer
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

end
