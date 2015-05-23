web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: env TERM_CHILD=1 COUNT=1 QUEUE=* bundle exec rake resque:work