require 'rspec'
require 'socket'
require './lib/custom_hash/custom_hash'
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
        @client_server.puts("get test")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        second_message = @client_server.gets.chop
        third_message = @client_server.gets.chop
        expect(first_message).to eq "VALUES test 1 4"
        expect(second_message).to eq "test"
        expect(third_message).to eq "END"
    end

    it "should return the value of test and test1" do 
        @client_server.puts("get test test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        second_message = @client_server.gets.chop
        third_message = @client_server.gets.chop
        message3 = @client_server.gets.chop
        message4 = @client_server.gets.chop
        expect(first_message).to eq "VALUES test 1 4"
        expect(second_message).to eq "test"
        expect(third_message).to eq "VALUES test1 2 5"
        expect(message3).to eq "test1"
        expect(message4).to eq "END"
    end

    it "should return END" do 
        @client_server.puts("get nonexistent_key")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        expect(first_message).to eq "END"
    end

    it "should return only the value of test" do 
        @client_server.puts("get nonexistent_key test")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        second_message = @client_server.gets.chop
        third_message = @client_server.gets.chop
        expect(first_message).to eq "VALUES test 1 4"
        expect(second_message).to eq "test"
        expect(third_message).to eq "END"
    end

    it "should return CLIENT_ERROR when the key has more than 250 characters" do 
        key = rand(36**251).to_s(36)
        @client_server.puts("get #{key}")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        expect(first_message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return END when the key has 250 characters but the key doesn't exists" do 
        key = rand(36**250).to_s(36)
        @client_server.puts("get #{key}")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        expect(first_message).to eq "END"
    end

    it "should return the value of the key when the key has 250" do 
        key = rand(36**250).to_s(36)
        @store.set("#{key}", 'test', 0, 1, 4, 1)
        @client_server.puts("get #{key}")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        second_message = @client_server.gets.chop
        third_message = @client_server.gets.chop
        expect(first_message).to eq "VALUES #{key} 1 4"
        expect(second_message).to eq "test"
        expect(third_message).to eq "END"
    end

    it "should return CLIENT_ERROR when the command only has one parameter" do 
        @client_server.puts("get")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandGet.new(@store, command, @server_accepted)
        first_message = @client_server.gets.chop
        expect(first_message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    after(:each) do
        @store = nil
        @client_server.close
        @server.close
    end

end

