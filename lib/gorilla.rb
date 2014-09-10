
module Gorilla
  class App < Sinatra::Base
    
    set :views, File.join(File.dirname(__FILE__), "../views")
    
    get "/" do
      erb :"index.html"
    end

    get "/dynamic/assets/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      puts "scheme: #{@scheme}"
      erb :"application.js"
    end
  end
end