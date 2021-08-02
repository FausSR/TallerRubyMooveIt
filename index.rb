require_relative './lib/socket_server'
require_relative './lib/custom_hash'
require_relative './config/environmental_variables'

env = EnvironmentalVariables.new
env.define_variables


  
$store = CustomHash.new
$store.set("algo", 0, 0,0)
$users = Hash.new
puts $store


socket = SocketServer.new($ENV["HOSTNAME"], $ENV["PORT"])
socket.start_server