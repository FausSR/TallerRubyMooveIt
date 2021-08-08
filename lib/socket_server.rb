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
        connections = []
        loop {              
            Thread.start(server.accept) do |client|
                connections.push client
                connection = ConnectionLogic.new(@store, client)
                connection.start_connection 
            end
        }
    rescue Exception => error
        connections.each do |client|
            client.puts("SERVER_ERROR #{error.message}\r\n")
            client.close
        end   
        raise error
    end
    

end



   