require 'socket'
require_relative './connection_logic'

class SocketServer
    def initialize(store, socket_address, socket_port)
        @socket_address = socket_address
        @socket_port = socket_port
        @store = store
    end

    def start_server
        server = TCPServer.open(@socket_port)
        loop {                           
            Thread.start(server.accept) do |client|
                connection = ConnectionLogic.new(@store, client)
                connection.start_connection  
            end
        }
    end

end



   