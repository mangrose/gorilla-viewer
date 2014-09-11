module Gorilla

  class Daemon 
    @queue = :aggregate
    
    def initialize
      puts "Initialized worker"
    end
    
    def self.perform(json)
      (new).perform_aggregation(json)
    end    
  
    def perform_aggregation(json)
      flush "Running background job with json-data: #{json}"
    end
    
    private 
    
    
    def flush(str)
      puts str
      $stdout.flush
    end
  end
  
end
