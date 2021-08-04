require 'socket'
require_relative '../exceptions/server_exception'

class Command

    def initialize
        @client
        @command
    end

    def storage_commands_lenght

        if ![5,6].include? @command.length 
            @client.puts("CLIENT_ERROR\r\n")
        else
            read_command()
        end
        
    end

    def retrieval_commands_lenght

        if @command.length <= 1
            @client.puts("CLIENT_ERROR\r\n")
        else
            read_command()
        end

    end

    def noreply (response)
        number_of_max_values = 6

        if(@command.length != number_of_max_values) && (!@command[5].eql?("noreply"))
            @client.puts(response)
        end
    end

    def server_error(error)
        @client.puts("SERVER_ERROR An error of type #{error} happened.\r\n")
        @client.close
        raise ServerException.new
    end


    def read_command; raise "SubclassResponsibility" ; end

end