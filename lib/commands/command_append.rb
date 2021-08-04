require 'socket'
require_relative '../custom_hash'
require_relative './command'

class CommandAppend < Command

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

        response = ""

        if !hash_value.nil?
            flags = command[2]
            expire = command[3]
            bytes = hash_value.length + command[4].to_i
            value = hash_value.value + client.gets.chop
            cas = hash_value.cas + 1
    
            $store.set(key, value, expire, flags, bytes, cas)
            response = "STORED #{'\r\n'}"

        else
            response = "NOT_STORED #{'\r\n'}"
        end

        number_of_max_values = 6

        if(command.length != number_of_max_values) && (!command[5].eql?("noreply"))
            client.puts(response)
        end
        


    end

end