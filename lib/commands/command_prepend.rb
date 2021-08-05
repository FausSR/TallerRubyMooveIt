require 'socket'
require_relative '../custom_hash'
require_relative './command'

class CommandPrepend < Command

    def initialize(command, client)
        @command = command
        @client = client

        storage_commands_lenght()

    end

    def read_command

        key = @command[1]
        hash_value = $store.get(key)

        response = ""

        if !hash_value.nil?
            flags = @command[2]
            expire = @command[3]
            bytes = hash_value.length + @command[4].to_i
            value = @client.gets.chop + hash_value.value
            cas = hash_value.cas + 1
    
            $store.set(key, value, expire, flags, bytes, cas)
            response = "STORED\r\n"

        else
            response = "NOT_STORED\r\n"
        end

        noreply(response)
    end

end