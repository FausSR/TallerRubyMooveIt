require 'socket'
require 'timeout'
require_relative '../exceptions/server_exception'
require_relative '../exceptions/client_exception'

class Command
    def initialize
        @client
        @command
        @timeout_data_block = $ENV["TIMEOUT_DATA_BLOCK"]
    end

    def storage_commands_lenght
        command_length = @command.length
        if (![5,6].include? command_length) || !storage_length_values()
            client_error()
        else
            read_command()
        end
    rescue ArgumentError
        client_error()
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

    def retrieval_commands_lenght 
        if (@command.length <= 1) || !retrieval_length_values()
            client_error()
        else
            read_command()
        end
    rescue ArgumentError => error
        client_error()
    end


    def storage_length_values
        return @command[1].length <=250 && 
                (Integer @command[2]) <= 65,535 && (Integer @command[3]) <= 2,592,000 
    end
    
    def cas_storage_length_values
        return @command[1].length <=250 && 
                (Integer @command[2]) <= 65,535 && (Integer @command[3]) <= 2,592,000 &&
                (Integer @command[4])
    end

    def retrieval_length_values
        return @command.all? {|x| x.length <=250}
    end

    def noreply (response)
        number_of_max_values = 6

        if(@command.length != number_of_max_values) && (!@command.last.eql?("noreply"))
            @client.puts(response)
        end
    end

    def cas_noreply (response)
        number_of_max_values = 7

        if(@command.length != number_of_max_values) && (!@command.last.eql?("noreply"))
            @client.puts(response)
        end
    end

    def server_error()
        raise ServerException.new
    end


    def client_error()
        raise ClientException.new
    end


    def read_command; raise "SubclassResponsibility" ; end

end

=begin


    def get_message_from_client
        response = ""
        Timeout.timeout(@timeout_data_block) do
            response = @client.gets.chop
        end
        response
    rescue Timeout::Error
        client_error()
    end
=end