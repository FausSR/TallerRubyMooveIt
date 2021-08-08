require 'socket'
require 'timeout'
require_relative './commands/command_get'
require_relative './commands/command_gets'
require_relative './commands/command_add'
require_relative './commands/command_set'
require_relative './commands/command_replace'
require_relative './commands/command_cas'
require_relative './commands/command_append'
require_relative './commands/command_prepend'



class ConnectionLogic

    def initialize(store, client)

        @client = client
        @timeout = $ENV["TIMEOUT"]
        @store = store
    end

    def start_connection
        puts "New Connection establish at #{Time.now.ctime}"
        line = ""
        while !line.nil?
            Timeout.timeout(@timeout) do
                if !(line = @client.gets).nil?
                    read_line(line.chop)
                else
                    line = nil
                    break
                end
            end
        end
        puts "Connection closed at #{Time.now.ctime}"
        @client.close
=begin
        loop{
            line = ""
            Timeout.timeout(@timeout) do
                line = @client.gets.chop
                read_line(line)
            end
        }
=end        
    rescue Timeout::Error
        puts "Connection closed at #{Time.now.ctime}"
        @client.close
    rescue StandardError  => error
        puts error.message
        puts "Connection closed at #{Time.now.ctime}"
        @client.puts("SERVER_ERROR #{error.message}\r\n")
        @client.close
    end

    private


    def read_line(line)
        command = line.split(" ")
        class_name = "Command#{command.first.capitalize}"
        Object.const_get(class_name).new(@store, command, @client)

    rescue NameError
        @client.puts("ERROR\r\n")
    #rescue ClientException => error
    #    @client.puts("CLIENT_ERROR #{error.message}\r\n")
    end

end