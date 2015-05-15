if ENV["REDISTOGO_URL"]
  $redis = Resque.redis = Redis.new(:url => ENV["REDISTOGO_URL"])
end