require_relative './lib/socket_connection/socket_client'
require_relative './config/environmental_variables'

env = EnvironmentalVariables.new
env.define_variables
socket = SocketClient.new($ENV["HOSTNAME"], $ENV["PORT"])
socket.start_client