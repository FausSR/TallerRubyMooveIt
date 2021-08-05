require 'socket'
require 'timeout'
require_relative './custom_hash'
require_relative './commands/command_get'
require_relative './commands/command_gets'
require_relative './commands/command_add'
require_relative './commands/command_set'
require_relative './commands/command_replace'
require_relative './commands/command_cas'
require_relative './commands/command_append'
require_relative './commands/command_prepend'
require_relative './exceptions/server_exception'
require_relative './exceptions/client_exception'



class ConnectionLogic

    def initialize(client)

        @client = client
        @timeout = $ENV["TIMEOUT"]
    end

    def start_connection
        puts "New Connection establish at #{Time.now.ctime}"
        loop{
            line = ""
            Timeout.timeout(@timeout) do
                line = @client.gets.chop
                read_line(line)
            end
            
        }

    rescue Timeout::Error
        puts "Connection closed at #{Time.now.ctime}"
        @client.close
    rescue ServerException, Exception => error
        puts error.message
        puts "Connection closed at #{Time.now.ctime}"
        @client.puts("SERVER_ERROR #{error.message}\r\n")
        @client.close
    end

    def read_line(line)
        command = line.split(" ")
        class_name = "Command#{command.first.capitalize}"
        Object.const_get(class_name).new(command, @client)

    rescue NameError
        @client.puts("ERROR\r\n")
    rescue ClientException => error
        @client.puts("CLIENT_ERROR #{error.message}\r\n")
    end

end