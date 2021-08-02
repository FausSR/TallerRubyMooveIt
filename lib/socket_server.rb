require 'socket'
require_relative './connection_logic'

class SocketServer

    def start_server
        server = TCPServer.open($ENV["PORT"])
        loop {                           
            Thread.start(server.accept) do |client|
                connection = ConnectionLogic.new
                connection.start_connection(client)    
            end
        }
    end

end



   