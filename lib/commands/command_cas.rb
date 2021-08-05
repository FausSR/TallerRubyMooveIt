require 'socket'
require_relative '../custom_hash'
require_relative './command'

class CommandCas < Command

    def initialize(command, client)
        @command = command
        @client = client

        cas_storage_commands_lenght()

    end

    def read_command

        key = @command[1]
        hash_value = $store.get(key)

        response = ""

        if !hash_value.nil?
            flags = @command[2]
            expire = @command[3]
            bytes = @command[4].to_i
            cas = @command[5].to_i
            if hash_value.cas == cas
                value = @client.gets.chop
    
                $store.set(key, value, expire, flags, bytes, cas + 1)
                response = "STORED\r\n"
            else
                response = "EXISTS\r\n"
            end
        else
            response = "NOT_FOUND\r\n"
        end

        cas_noreply(response)
    end

end