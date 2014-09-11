module Gorilla

  class Daemon 
    @queue = :aggregate
    CHANNEL = "gorilla-pipeline"

    def initialize
      puts "Initialized worker"
      redis_url = ENV["REDISCLOUD_URL"]
      uri = URI.parse(redis_url)
      @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end
    
    def self.perform(json)
      (new).perform_aggregation(json)
    end    
  
    def perform_aggregation(json)
      flush "Running background job with json-data: #{json}"
      data = JSON.parse(json, :symbolize_names => true)
      flush data.inspect
      payload = {:handle => "aggregator", :text => data[:text]}.to_json
      @redis.publish(CHANNEL, payload)
      flush "published result"
    end
    
    private 
    
    
    def flush(str)
      puts str
      $stdout.flush
    end
  end
  
end
