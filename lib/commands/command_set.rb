require 'socket'
require_relative '../custom_hash'
require_relative './command'

class CommandSet < Command

    def initialize(command, client)
        @command = command
        @client = client

        storage_commands_lenght()
        
    end

    def read_command

        key = @command[1]
        flags = @command[2]
        expire = @command[7]
        puts expire
        bytes = @command[4].to_i
        value = @client.gets.chop[0..(bytes -1)]
        $store.set(key, value, expire, flags, bytes)
        puts $store.get("algo")

        response = "STORED\r\n"

        noreply(response)

    rescue Exception => error
        server_error(error.class)
    end

end