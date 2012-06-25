require 'resque_scheduler'
require 'resque_scheduler/server'

uri = URI.parse("redis://0.0.0.0:6379/")  
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
