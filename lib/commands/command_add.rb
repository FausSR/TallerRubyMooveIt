require 'socket'
require_relative '../custom_hash'
require_relative './command'

class CommandAdd < Command

    def initialize(command, client)

        if !storage_commands_lenght(command)
            client.puts("CLIENT_ERROR\r\n")
        else
            read_command(command, client)
        end

    end

    def read_command(command, client)

        key = command[1]
        hash_value = $store.get(key)

        if hash_value.nil?
            flags = command[2]
            expire = command[3]
            bytes = command[4].to_i
            value = client.gets.chop
    
            $store.set(key, value, expire, flags, bytes)
    
            number_of_max_values = 6
    
            if(command.length != number_of_max_values) && (!command[5].eql?("noreply"))
                client.puts("STORED #{'\r\n'}")
            end
        else
            client.puts("NOT_STORED #{'\r\n'}")
        end

    end

end