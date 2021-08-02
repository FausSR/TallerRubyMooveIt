require 'socket'

class SocketClient
    def initialize(socket_address, socket_port)
        @socket_address = socket_address
        @socket_port = socket_port
    end

    def start_client
        s = TCPSocket.open(@socket_address, @socket_port)

        while !(line = gets).eql?("END")
            s.print(line)     
        end

        s.close
    end

end