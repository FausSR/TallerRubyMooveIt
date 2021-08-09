require 'rspec'
require 'socket'
require './lib/custom_hash/custom_hash'
require './lib/socket_connection/connection_logic'

describe CommandAdd do 

    before(:each) do
        socket_address = 'localhost'
        socket_port = 2000
        @server = TCPServer.open(socket_port)
        @client_server = TCPSocket.open(socket_address, socket_port)
        @server_accepted = @server.accept
        @store = CustomHash.new
        @store.set("test", 'test', 0, 1, 4, 1)
        @store.set("test1", 'test1', 0, 2, 5, 2)
        $ENV = {"TIMEOUT" => 30}
    end

    it "should return STORED when send a wrong command to ConnectionLogic" do 
        @client_server.puts("set test3 1 0 5")
        @client_server.puts("test3") 
        thread = Thread.new do
            connection = ConnectionLogic.new(@store, @server_accepted)
            connection.start_connection
        end
        message = @client_server.gets.chop
        thread.kill  
        expect(message).to eq "STORED"
    end

    it "should return ERROR when send a wrong command to ConnectionLogic" do 
        @client_server.puts("sett test3 1 0 5")
        thread = Thread.new do
            connection = ConnectionLogic.new(@store, @server_accepted)
            connection.start_connection
        end
        message = @client_server.gets.chop
        thread.kill       
        expect(message).to eq "ERROR"
    end

    it "should not rise error when read_line rise a StandarError" do 
        connection = ConnectionLogic.new(@store, @server_accepted)
        @client_server.puts("test")
        allow(connection).to receive(:read_line) { raise StandardError.new "error" }
        expect { connection.start_connection }.to_not raise_error
    end

    it "should return 'SERVER_ERROR error' when read_line rise a StandarError" do 
        connection = ConnectionLogic.new(@store, @server_accepted)
        @client_server.puts("test")
        allow(connection).to receive(:read_line) { raise StandardError.new "error" }
        thread = Thread.new do
            connection.start_connection
        end
        message = @client_server.gets.chop
        thread.kill
        expect(message).to eq "SERVER_ERROR error"
    end

    it "should not raise error when Timout rise a Timeout::Error" do 
        connection = ConnectionLogic.new(@store, @server_accepted)
        allow(Timeout).to receive(:timeout) { raise Timeout::Error }
        expect { connection.start_connection }.to_not raise_error
    end

    after(:each) do
        $ENV = nil
        $store = nil
        @client_server.close
        @server.close
    end

end

