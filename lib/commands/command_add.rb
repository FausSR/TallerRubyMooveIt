require 'socket'
require_relative '../custom_hash'

class CommandAdd

    def initialize(command, client)

        read_command(command, client)

    end

    def read_command(command, client)

        key = command[0]
        hash_value = $store.get(key)

        if hash_value.nil?
            flags = command[1]
            expire = command[2]
            bytes = command[3].to_i
            value = client.gets.chop
    
            $store.set(key, value, expire, flags, bytes)
    
            number_of_max_values = 6
    
            if(command.length != number_of_max_values) && (!command[4].eql?("noreply"))
                client.puts("STORED #{'\r\n'}")
            end
        else
            client.puts("NOT_STORED #{'\r\n'}")
        end

    end

end