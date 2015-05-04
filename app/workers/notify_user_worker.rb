class NotifyUserWorker
  @queue = :notify_user

  def self.perform(event)
    #Check uber time
    #Send twilio notification
    puts "Inside NotifyUserWorker background job"
  end
end