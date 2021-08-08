require 'socket'
require_relative '../custom_hash/custom_hash'
require_relative './storage_command'

class CommandCas < StorageCommand

    def initialize(store, command, client)
        @command = command
        @client = client
        @store = store
        @length = 7

        storage_commands_lenght()

    end

    def read_command

        key = @command[1]
        hash_value = @store.get(key)

        response = ""

        if !hash_value.nil?
            flags = @command[2]
            expire = @command[3]
            bytes = @command[4].to_i
            cas = @command[5].to_i
            if hash_value.cas == cas
                value = @client.gets.chop
    
                @store.set(key, value, expire, flags, bytes, cas + 1)
                response = "STORED\r\n"
            else
                response = "EXISTS\r\n"
            end
        else
            response = "NOT_FOUND\r\n"
        end

        noreply(response)
    end

end