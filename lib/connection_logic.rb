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
        case command.shift
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
            else
                @client.puts('ERROR\r\n')
        end
    end

    def get_command(command)

        command.each { |x|
            hash_value = $store.get(x)

            if !hash_value.nil?

                ret = []

                value = hash_value[0].to_s + ' \r\n'
                ret.push(x)
                ret.push(hash_value[4])
                ret.push(hash_value[5])

                response = "VALUES #{ret.join(" ") + ' \r\n'}"

                @client.puts(response)
                @client.puts(value)

            end
        }
        @client.puts("END #{'\r\n'}")
    end

    def gets_command(command)
 
        command.each { |x|
            hash_value = $store.get(x)

            if !hash_value.nil?

                ret = []

                value = hash_value[0].to_s + ' \r\n'
                ret.push(x)
                ret.push(hash_value[4])
                ret.push(hash_value[5])
                ret.push(hash_value[6]) if !hash_value[6].nil?

                response = "VALUES #{ret.join(" ") + ' \r\n'}"

                @client.puts(response)
                @client.puts(value)

            end
        }
        @client.puts("END#{'\r\n'}")
    end

    def set_command(command)
        
        key = command[0]
        flags = command[1]
        expire = command[2]
        bytes = command[3].to_i
        value = @client.gets.chop[0..(bytes -1)]

        $store.set(key, value, expire, "x", flags, bytes)

        number_of_max_values = 6
        

        if(command.length != number_of_max_values) && (!command[4].eql?("noreply"))
            @client.puts("STORED #{'\r\n'}")
        end
        
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