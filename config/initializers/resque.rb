require "resque/server"

config = YAML.load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
Resque.redis = Redis.new( :host => config[:host], :port => config[:port], :db => config[:db] )
Resque.redis.namespace = "resque:hackathon"
