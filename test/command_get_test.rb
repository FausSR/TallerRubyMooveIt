require 'rspec'
require 'socket'
require './lib/custom_hash'
require './lib/commands/command_get'

describe CommandGet do 

    before(:each) do
        socket_address = 'localhost'
        socket_port = 2000
        @server = TCPServer.open(socket_port)

        @client_server = TCPSocket.open(socket_address, socket_port)

        @server_accepted = @server.accept

        @store = CustomHash.new
        @store.set("test", 'test', 0, 1, 4)
        @store.set("test1", 'test1', 0, 2, 5)

    end

       
    it "should return the value of test" do 
        $store = @store
        @client_server.puts("get test")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGet.new(command, @server_accepted)
        
        message = @client_server.gets.chop
        message1 = @client_server.gets.chop
        message2 = @client_server.gets.chop

        expect(message).to eq "VALUES test 1 4"
        expect(message1).to eq "test"
        expect(message2).to eq "END"
    end

    it "should return the value of test and test1" do 
        $store = @store
        @client_server.puts("get test test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGet.new(command, @server_accepted)
        
        message = @client_server.gets.chop
        message1 = @client_server.gets.chop
        message2 = @client_server.gets.chop
        message3 = @client_server.gets.chop
        message4 = @client_server.gets.chop

        expect(message).to eq "VALUES test 1 4"
        expect(message1).to eq "test"
        expect(message2).to eq "VALUES test1 2 5"
        expect(message3).to eq "test1"
        expect(message4).to eq "END"
    end

    it "should return END" do 
        $store = @store
        @client_server.puts("get nonexistent_key")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGet.new(command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "END"
    end

    it "should return only the value of test" do 
        $store = @store
        @client_server.puts("get nonexistent_key test")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGet.new(command, @server_accepted)
        
        message = @client_server.gets.chop
        message1 = @client_server.gets.chop
        message2 = @client_server.gets.chop

        expect(message).to eq "VALUES test 1 4"
        expect(message1).to eq "test"
        expect(message2).to eq "END"
    end

    it "should return CLIENT_ERROR" do 
        $store = @store
        @client_server.puts("get testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttetest")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGet.new(command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    after(:each) do
        $store = nil
        @client_server.close
        @server.close
    end
end

