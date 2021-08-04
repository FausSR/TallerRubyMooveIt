require 'socket'
require_relative '../custom_hash'

class CommandAppend

    def initialize(command, client)

        read_command(command, client)

    end

    def read_command(command, client)

        key = command[0]
        flags = command[1]
        expire = command[2]
        bytes = command[3].to_i
        value = client.gets.chop[0..(bytes -1)]

        $store.set(key, value, expire, flags, bytes)

        number_of_max_values = 6

        if(command.length != number_of_max_values) && (!command[4].eql?("noreply"))
            client.puts("STORED #{'\r\n'}")
        end

    end

end