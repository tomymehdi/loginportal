require 'em-websocket'
require 'em-websocket-client'
require 'pry'
require 'json'
require 'rubygems'

EM.run do
  conn = EventMachine::WebSocketClient.connect("ws://localhost:8080/")
  aux = LibWebSocket::OpeningHandshake::Client.new(:url => "ws://localhost:8080/")  
  connected = nil

  conn.callback do
    puts "a"
    conn.send_msg "Hello!"
    conn.send_msg "done"
    binding.pry
    puts connected?
    binding.pry
  end

  conn.errback do |e|
    puts "Got error: #{e}"
  end

  conn.stream do |msg|
    puts "<#{msg}>"
    if msg == "done"
      conn.close_connection
    end
  end

  conn.disconnect do
    puts connected?
    puts "gone"
    EM::stop_event_loop
  end

  conn.connection_completed do
    connected = true
  end

  def connected?
    !!connected
  end

  conn.unbind do
    connected = false
  end



end





