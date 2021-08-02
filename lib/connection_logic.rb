require 'socket'

class ConnectionLogic

    def start_connection (client)
   
        puts "New Connection establish at #{Time.now.ctime}"

        while !(line = client.gets.chop).eql?("END")      
            puts line       
        end

        puts "Connection closed at #{Time.now.ctime}"
        client.close

    end

end