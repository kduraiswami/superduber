web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
scheduler:  bundle exec rake resque:scheduler
worker: env QUEUE=* bundle exec rake resque:work