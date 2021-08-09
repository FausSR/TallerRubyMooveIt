require_relative './lib/socket_connection/socket_server'
require_relative './lib/custom_hash/custom_hash'
require_relative './lib/custom_hash/custom_hash_value'
require_relative './lib/custom_hash/key_purger'
require_relative './config/environmental_variables'

env = EnvironmentalVariables.new
env.define_variables

store = CustomHash.new
store.set("algo", 'algo\nsorry\n', 0, 0, 1)
store.set("algo1", 3, 0, 0, 1)
store.set("algo2", 3, 20, 0, 1)
store.set("algo3", 3, 30, 0, 1)
puts store.get("algo").value
puts store.get("algo").expiry
puts store.get("algo").flags
puts store.get("algo").length
puts store.get("algo").cas

Thread.new { KeyPurger.new(store) }

socket = SocketServer.new(store, $ENV["HOSTNAME"], $ENV["PORT"])
socket.start_server()