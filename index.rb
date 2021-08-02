require_relative './lib/socket_server'
require_relative './config/environmental_variables'

env = EnvironmentalVariables.new
env.define_variables

socket = SocketServer.new($ENV["HOSTNAME"], $ENV["PORT"])
socket.start_server