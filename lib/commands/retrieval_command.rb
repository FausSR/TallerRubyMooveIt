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

    private


    def retrieval_commands_lenght 
        if  retrieval_length_values()
            read_command()
        else
            client_error()
        end
    rescue ArgumentError => error
        client_error()
    end


    def retrieval_length_values
        return false if (@command.length <= 1)
        
        return @command.all? {|x| x.length <=250}
    end


    #def server_error()
    #    raise ServerException.new
    #end


    def client_error()
        @client.puts("CLIENT_ERROR Hubo un problema con los parametros del comando.\r\n")
    end


    def read_command; raise "SubclassResponsibility" ; end

end