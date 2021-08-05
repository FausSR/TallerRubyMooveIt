require 'socket'
require 'timeout'
require_relative '../exceptions/server_exception'
require_relative '../exceptions/client_exception'

class RetrievalCommand
    def initialize
        @client
        @command
        @store
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


    def retrieval_length_values
        return @command.all? {|x| x.length <=250}
    end
    

    def server_error()
        raise ServerException.new
    end


    def client_error()
        @client.puts("CLIENT_ERROR Hubo un problema con los parametros del comando.\r\n")
    end


    def read_command; raise "SubclassResponsibility" ; end

end