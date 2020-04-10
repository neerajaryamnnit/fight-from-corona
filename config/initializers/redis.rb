uri = URI.parse(ENV["REDIS_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
REDIS.set("LOCALE", ENV["LOCALE"])