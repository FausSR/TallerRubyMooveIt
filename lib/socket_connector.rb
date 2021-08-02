require 'socket'        # Sockets are in standard library
require_relative '../config/environmental_variables'


env = EnvironmentalVariables.new
env.define_variables()

hostname = $ENV["HOSTNAME"]
port = $ENV["PORT"]

s = TCPSocket.open(hostname, port)


while !(line = gets).eql?("END")
    s.print(line)     
end

s.close      