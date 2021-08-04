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



class ConnectionLogic

    def initialize(client)

        @client = client
        @timeout = $ENV["TIMEOUT"]
    end

    def start_connection
        puts "New Connection establish at #{Time.now.ctime}"
        loop{
            Timeout.timeout(@timeout) do
                line = @client.gets.chop
                read_line(line)
            end
        }

    rescue Timeout::Error
        puts "Connection closed at #{Time.now.ctime}"
        @client.close
    rescue ServerException => error
        puts error.message
        puts "Connection closed at #{Time.now.ctime}"
        @client.close

    end

    def read_line(line)
        command = line.split(" ")
        class_name = "Command#{command.first.capitalize}"
        Object.const_get(class_name).new(command, @client)
    end
end