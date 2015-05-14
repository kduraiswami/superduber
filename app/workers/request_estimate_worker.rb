class RequestEstimateWorker
  @queue = :request_estimate

  def self.perform(event_hash)
    event_id = event_hash['_id']['$oid']
    event = Event.find(event_id) # returns actual event object
    event.schedule_bg_job
    puts "Inside RequestEstimateWorker background job"
  end
end