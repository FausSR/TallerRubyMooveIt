require 'socket'
require_relative '../custom_hash/custom_hash'
require_relative './storage_command'

class CommandSet < StorageCommand

    def initialize(store, command, client)
        @command = command
        @client = client
        @store = store
        @length = 6

        storage_commands_lenght
        
    end

    private

    def read_command

        key = @command[1]
        flags = @command[2]
        expire = @command[3]
        bytes = @command[4].to_i
        value = @client.gets.chop[0..(bytes -1)]
        @store.set(key, value, expire, flags, bytes)

        response = "STORED\r\n"

        noreply(response)
    end

end