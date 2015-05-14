class NotifyUserWorker
  @queue = :notify_user

  def self.perform(event_hash)
    puts "INSIDE NotifyUserWorker background job.  EVENT:"
    puts event_hash
    event_id = event_hash['_id']['$oid']
    event = Event.find(event_id) # this returns the actual event object, not just a hash of its data
    event.twilio_upcoming_event_notification #Send twilio notification

  end
end