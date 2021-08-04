require 'socket'
require_relative '../custom_hash'

class CommandGet

    def initialize(command, client)

        read_command(command, client)

    end
 
    def read_command(command, client)

        command.each { |key|
            create_get_response(key, client)
        }
        client.puts("END\r\n")
    end

    def create_get_response(key, client)
        hash_value = $store.get(key)

        if !hash_value.nil?

            ret = []
            value = hash_value.value.to_s + "\r\n"
            ret.push(key)
            ret.push(hash_value.flags)
            ret.push(hash_value.length)

            response = "VALUES #{ret.join(" ")}\r\n"

            client.puts(response)
            client.puts(value)
        end
    end

end

#   def initialize(command, client)
#
#        read_command(command, client)
#
#    end