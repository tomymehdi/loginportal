require 'em-websocket'
require 'fetcher-mongoid-models'
require 'json'

Fetcher::Mongoid::Models::Db.new "/home/fetcher/code/loginportal/omniauth/config/bd.yaml"

EventMachine.run do
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 7979) do |ws|
      ws.onopen {
        puts "WebSocket connection open"

        # publish message to the client
        # ws.send "Hello Client"
      }

      ws.onclose { puts "Connection closed" }

      ws.onmessage { |msg|
        puts "Recieved message: #{msg}"
        resp = JSON.parse(msg)
        
        #binding.pry

        # ws.send "Pong: #{msg}"
      }
  end
end