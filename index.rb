require_relative './lib/socket_connection/socket_server'
require_relative './lib/custom_hash/custom_hash'
require_relative './lib/custom_hash/custom_hash_value'
require_relative './lib/custom_hash/key_purger'
require_relative './config/environmental_variables'

env = EnvironmentalVariables.new
env.define_variables
store = CustomHash.new
Thread.new { KeyPurger.new(store) }
socket = SocketServer.new(store, $ENV['HOSTNAME'], $ENV['PORT'])
socket.start_server
