require 'em-websocket'

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
          # ws.send "Pong: #{msg}"
        }
    end
end