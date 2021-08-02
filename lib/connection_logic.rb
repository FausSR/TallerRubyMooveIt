require 'socket'
require 'timeout'
require_relative './custom_hash'

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
    end

    def read_line(line)
        puts line
        command = line.split(" ")
        case command[0]
            when "get"
                get_command(command)
            when "gets"
                gets_command(command)
            when "set"
                set_command(command)
            when "add"
                add_command(command)
            when "replace"
                replace_command(command)
            when "append"
                append_command(command)
            when "prepend"
                prepend_command(command)
            when "cas"
                cas_command(command)
        end
    end

    def get_command(command)
        
    end
    
    def gets_command(command)
        
    end
    
    def set_command(command)
        
    end
    
    def add_command(command)
        
    end
    
    def replace_command(command)
        
    end
    
    def append_command(command)
        
    end
    
    def prepend_command(command)
        
    end 
    
    def cas_command(command)
        
    end
end