class RequestEstimateWorker
  @queue = :request_estimate

  def self.perform(event)
    event.schedule_bg_job
    puts "Inside RequestEstimateWorker background job"
  end
end