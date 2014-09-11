require 'sinatra/redis'
module Gorilla
  class App < Sinatra::Base
    
    CHANNEL = "gorilla-pipeline"

    configure do
      redis_url = ENV["REDISCLOUD_URL"]
      uri = URI.parse(redis_url)
      Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
      Resque.redis.namespace = "resque:example"
      puts "Configured Resque"
      set :redis, redis_url
      set :views, File.join(File.dirname(__FILE__), "../views")
    end
    
    get "/" do
      erb :"index.html"
    end

    post '/receive' do
      json = request.body.read
      Resque.enqueue(Gorilla::Daemon, json)
    end
    
    get "/dynamic/assets/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      puts "scheme: #{@scheme}"
      erb :"application.js"
    end
    
    private
    
    def publish(handle, message)
      data = {:handle => handle, :text => message}.to_json
      redis.publish(CHANNEL, sanitize(data))
    end
    
    def sanitize(message)
      json = JSON.parse(message)
      json.each {|key, value| json[key] = ERB::Util.html_escape(value) }
      JSON.generate(json)
    end
  end
end