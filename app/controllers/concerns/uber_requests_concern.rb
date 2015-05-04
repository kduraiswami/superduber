module UberRequestsConcern
  extend ActiveSupport::Concern

  # def schedule_bg_job(event)
  #   event.update_estimate!
  #   next_bg_job_time(event)
  #   #create background Resque job
  #   Resque.enqueue_in(10.seconds, PrintWorker, event.estimated_duration_minutes.to_s)

  # end

  # def next_bg_job_time(event)
  #   notification_buffer = 10
  #   current_time = Time.now
  #   time_until_event = event.arrival_datetime - current_time
  #   time_until_notify_user = time_until_event - event.estimated_duration_minutes - notification_buffer
  #   return time_until_next_bg_job = (time_until_notify_user / 2).to_i
  # end



end