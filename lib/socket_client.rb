require 'socket'

class SocketClient
    def initialize(socket_address, socket_port)
        @socket_address = socket_address
        @socket_port = socket_port
    end

    def start_client
        s = TCPSocket.open(@socket_address, @socket_port)

        Thread.start do
            while line = s.gets 
                puts line.chop  
            end
        end

        while !(line = gets).eql?("EXIT")
            s.print(line)     
        end

        s.close
    end

end