require_relative './lib/socket_server'
require_relative './lib/custom_hash'
require_relative './config/environmental_variables'

env = EnvironmentalVariables.new
env.define_variables

$store = CustomHash.new
$store.set("algo", 0, 60, "", 0, 1)
$store.set("algo1", 3, 60, "",0, 1)
$users = Hash.new
puts $store.get("algo")

socket = SocketServer.new($ENV["HOSTNAME"], $ENV["PORT"])
socket.start_server