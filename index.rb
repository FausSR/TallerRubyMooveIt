require_relative './lib/socket_connection/socket_server'
require_relative './lib/custom_hash/custom_hash'
require_relative './lib/custom_hash/custom_hash_value'
require_relative './lib/custom_hash/key_purger'
require_relative './config/environmental_variables'

env = EnvironmentalVariables.new
env.define_variables
store = CustomHash.new

key_purger = KeyPurger.new(store)

Thread.start {
    loop do
        key_purger.purge_keys()
        sleep($ENV["KEYPURGER"])
    end
}

socket = SocketServer.new(store, $ENV['HOSTNAME'], $ENV['PORT'])
socket.start_server
