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
        loop do
            Thread.start(server.accept) do |client|
                connections.push client
                connection = ConnectionLogic.new(@store, client)
                connection.start_connection
            end
        end
    rescue Exception => e
        connections.each do |client|
            client.puts("SERVER_ERROR #{e.message}\r\n")
            client.close
        end
        raise e
    end

end
