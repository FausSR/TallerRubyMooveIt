require 'socket'
require_relative '../custom_hash'
require_relative './retrieval_command'

class CommandGets < RetrievalCommand

    def initialize(store, command, client)
        @command = command
        @client = client
        @store = store

        retrieval_commands_lenght()
        
    end
 
    def read_command

        @command.drop(1)
        @command.each { |key|
            create_get_response(key)
        }
        @client.puts("END\r\n")
    end

    def create_get_response(key)

        hash_value = @store.get(key)

        if !hash_value.nil?
            ret = []
            value = hash_value.value.to_s + "\r\n"
            ret.push(key)
            ret.push(hash_value.flags)
            ret.push(hash_value.length)
            ret.push(hash_value.cas)

            response = "VALUES #{ret.join(" ")}\r\n"

            @client.puts(response)
            @client.puts(value)
        end
    end

end

#   def initialize
#
#        read_command
#
#    end