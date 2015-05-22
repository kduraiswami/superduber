web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec rake resque:work COUNT=1 QUEUE=*
