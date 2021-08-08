require 'rspec'
require 'socket'
require './lib/custom_hash/custom_hash'
require './lib/commands/command_gets'

describe CommandGets do 

    before(:each) do
        socket_address = 'localhost'
        socket_port = 2000
        @server = TCPServer.open(socket_port)

        @client_server = TCPSocket.open(socket_address, socket_port)

        @server_accepted = @server.accept

        @store = CustomHash.new
        @store.set("test", 'test', 0, 1, 4, 1)
        @store.set("test1", 'test1', 0, 2, 5, 2)

    end

       
    it "should return the value of test" do 
        
        @client_server.puts("gets test")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop
        message1 = @client_server.gets.chop
        message2 = @client_server.gets.chop

        expect(message).to eq "VALUES test 1 4 1"
        expect(message1).to eq "test"
        expect(message2).to eq "END"
    end

    it "should return the value of test and test1" do 
        
        @client_server.puts("gets test test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop
        message1 = @client_server.gets.chop
        message2 = @client_server.gets.chop
        message3 = @client_server.gets.chop
        message4 = @client_server.gets.chop

        expect(message).to eq "VALUES test 1 4 1"
        expect(message1).to eq "test"
        expect(message2).to eq "VALUES test1 2 5 2"
        expect(message3).to eq "test1"
        expect(message4).to eq "END"
    end

    it "should return END" do 
        
        @client_server.puts("gets nonexistent_key")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "END"
    end

    it "should return only the value of test" do 
        
        @client_server.puts("gets nonexistent_key test 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop
        message1 = @client_server.gets.chop
        message2 = @client_server.gets.chop

        expect(message).to eq "VALUES test 1 4 1"
        expect(message1).to eq "test"
        expect(message2).to eq "END"
    end

    it "should return CLIENT_ERROR when the key has more than 250 characters" do 
        key = rand(36**251).to_s(36)
        @client_server.puts("gets #{key}")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return END when the key has 250 characters but the key doesn't exists" do 
        key = rand(36**250).to_s(36)
        @client_server.puts("gets #{key}")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "END"
    end

    it "should return the value of the key when the key has 250" do 
        key = rand(36**250).to_s(36)
        @store.set("#{key}", 'test', 0, 1, 4, 1)
        @client_server.puts("gets #{key}")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop
        message1 = @client_server.gets.chop
        message2 = @client_server.gets.chop

        expect(message).to eq "VALUES #{key} 1 4 1"
        expect(message1).to eq "test"
        expect(message2).to eq "END"
    end

    it "should return CLIENT_ERROR when the command only has one parameter" do 
        @client_server.puts("gets")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandGets.new(@store, command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    after(:each) do
        @store = nil
        @client_server.close
        @server.close
    end
end

