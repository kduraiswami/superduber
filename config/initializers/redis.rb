if ENV["REDISCLOUD_URL"]
  $redis = Resque.redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
end