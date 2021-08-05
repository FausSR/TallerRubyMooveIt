require 'socket'
require 'timeout'
require_relative '../exceptions/server_exception'
require_relative '../exceptions/client_exception'

class CasCommand
    def initialize
        @client
        @command
        @store
    end


    def cas_storage_commands_lenght
        if (![6,7].include? @command.length) || !cas_storage_length_values()
            client_error()
        else
            read_command()
        end
    rescue ArgumentError
        client_error()
    end


    def cas_storage_length_values
        return (@command[1].length <=250) && 
                ((Integer @command[2]) <= 65535) && ((Integer @command[3]) <= 2592000) &&
                ((Integer @command[4]))
    end


    def cas_noreply (response)
        number_of_max_values = 7

        if((@command.length != number_of_max_values) && (!@command.last.eql?("noreply"))) || (!response.eql?("STORED\r\n"))
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