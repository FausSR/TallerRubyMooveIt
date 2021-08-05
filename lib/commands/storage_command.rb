require 'socket'
require 'timeout'
require_relative '../exceptions/server_exception'
require_relative '../exceptions/client_exception'

class StorageCommand
    def initialize
        @client
        @command
        @store
        @length
    end


    def storage_commands_lenght()
        if (![@length-1,@length].include?(@command.length)) || (!storage_length_values())
            client_error()
        else
            read_command()
        end
    rescue ArgumentError
        client_error()
    end


    def storage_length_values()

        (Integer @command[4]) if @length.eql? 7

        return false if ((@command.length.eql? @length) && !(@command.last.eql?("noreply")))

        return ((@command[1].length <=250) && ((Integer @command[2]) <= 65535) && ((Integer @command[3]) <= 2592000) )
    end


    def noreply (response)

        if((@command.length != @length) && (!@command.last.eql?("noreply"))) || (!response.eql?("STORED\r\n"))
            @client.puts(response)
        end
    end
    

    def server_error()
        raise ServerException.new
    end


    def client_error()
        @client.puts("CLIENT_ERROR Hubo un problema con los parametros del comando.\r\n")
    end


    def read_command; raise "SubclassResponsibility" ; end

end