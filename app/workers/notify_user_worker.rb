class NotifyUserWorker
  @queue = :notify_user

  def self.perform(event)
    #Check uber time
    event.twilio_upcoming_event_notification

    #Send twilio notification



    puts "Inside NotifyUserWorker background job"
  end
end