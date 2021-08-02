require 'socket'
require_relative './connection_logic'

class SocketServer
    def initialize(socket_address, socket_port)
        @socket_address = socket_address
        @socket_port = socket_port
    end

    def start_server
        server = TCPServer.open(@socket_address, @socket_port)
        loop {                           
            Thread.start(server.accept) do |client|
                connection = ConnectionLogic.new
                connection.start_connection(client)    
            end
        }
    end

end



   