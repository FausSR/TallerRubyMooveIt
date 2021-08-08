require 'socket'
require_relative '../custom_hash/custom_hash'
require_relative './storage_command'

class CommandAdd < StorageCommand

    def initialize(store, command, client)
        @command = command
        @client = client
        @store = store
        @length = 6

        storage_commands_lenght()

    end

    def read_command

        key = @command[1]
        hash_value = @store.get(key)

        response = ""

        if hash_value.nil?
            flags = @command[2]
            expire = @command[3]
            bytes = @command[4].to_i
            value = @client.gets.chop
    
            @store.set(key, value, expire, flags, bytes)

            response = "STORED\r\n"
        else
            response = "NOT_STORED\r\n"
        end

        noreply(response)
    end

end