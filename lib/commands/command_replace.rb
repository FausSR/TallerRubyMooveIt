require 'socket'
require_relative '../custom_hash'

class CommandReplace

    def initialize(command, client)

        read_command(command, client)

    end

    def read_command(command, client)

        key = command[0]
        hash_value = $store.get(key)

        response = ""

        if !hash_value.nil?
            flags = command[1]
            expire = command[2]
            bytes = command[3].to_i
            value = client.gets.chop
            cas = hash_value.cas
    
            $store.set(key, value, expire, flags, bytes, cas+1)
            response = "STORED #{'\r\n'}"

        else
            response = "NOT_STORED #{'\r\n'}"
        end

        number_of_max_values = 5

        if(command.length != number_of_max_values) && (!command[4].eql?("noreply"))
            client.puts(response)
        end

    end

end