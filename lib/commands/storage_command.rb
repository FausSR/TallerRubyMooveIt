require 'socket'
require 'timeout'
require_relative '../exceptions/client_exception'

class StorageCommand
    
    def initialize
        @client
        @command
        @store
        @length
    end

    private

    def storage_commands_lenght()
        if  storage_length_values()
            read_command()
        else
            client_error()
        end
    rescue ArgumentError, RangeError, TypeError
        client_error()
    end

    def storage_length_values()
        return false if (![@length-1,@length].include?(@command.length))
        (Integer @command[4]) if @length.eql? 7
        return false if ((@command.length.eql? @length) && !(@command.last.eql?("noreply")))
        return ((@command[1].length <=250) && ((Integer @command[2]) <= 65535) && ((Integer @command[3]) <= 2592000) )
    end

    def noreply (response)
        if (@command.length != @length) || (!response.eql?("STORED\r\n"))
            @client.puts(response)
        end
    end

    def client_error()
        @client.puts("CLIENT_ERROR Hubo un problema con los parametros del comando.\r\n")
    end

    def read_command; raise "SubclassResponsibility" ; end

end