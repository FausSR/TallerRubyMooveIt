require 'rspec'
require 'socket'
require './lib/custom_hash/custom_hash'
require './lib/commands/command_set'

describe CommandSet do 

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

    it "should return STORED when set a new key" do 
        @client_server.puts("set test3 1 0 5")
        @client_server.puts("test3")
        line = @server_accepted.gets.chop
        command = line.split(" ")     
        command_get = CommandSet.new(@store ,command, @server_accepted)              
        message = @client_server.gets.chop
        expect(message).to eq "STORED"
    end

    it "should be created the key into the storage" do 
        @client_server.puts("set test3 1 0 5")
        @client_server.puts("test3")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)       
        message = @client_server.gets.chop
        value = @store.get("test3")
        expect(value.value).to eq "test3"
        expect(value.expiry).to eq 0
        expect(value.flags).to eq 1
        expect(value.length).to eq 5
        expect(value.cas).to eq 1
    end

    it "should return nothing when set a new key and use the parameter noreply" do 
        @client_server.puts("set test3 1 0 5 noreply")
        @client_server.puts("test3")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)       
        @server_accepted.puts("Message to confirm that there is no response.")
        message = @client_server.gets.chop
        expect(message).to eq "Message to confirm that there is no response."
    end

    it "should return STORED when set an existant key" do 
        @client_server.puts("set test 1 0 5")
        @client_server.puts("test3")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)       
        message = @client_server.gets.chop
        expect(message).to eq "STORED"
    end

    it "should return CLIENT_ERROR when the command only has one parameter" do 
        @client_server.puts("set")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command only has two parameters" do 
        @client_server.puts("set test")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command only has three parameters" do 
        @client_server.puts("set test 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command only has four parameters" do 
        @client_server.puts("set test 1 0")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command has more than five parameters" do 
        @client_server.puts("set test 1 0 noreply 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)        
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the key has more than 250 characters" do 
        key = rand(36**251).to_s(36)
        @client_server.puts("set #{key} 1 0 5")
        line = @server_accepted.gets.chop
        command = line.split(" ")        
        command_get = CommandSet.new(@store ,command, @server_accepted)         
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return STORED when set an existant key with 250 characters" do 
        key = rand(36**250).to_s(36)
        @client_server.puts("set #{key} 1 0 5")
        @client_server.puts("test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")        
        command_get = CommandSet.new(@store ,command, @server_accepted)     
        message = @client_server.gets.chop
        expect(message).to eq "STORED"
    end

    it "should return CLIENT_ERROR when the flag value is greater than 65535" do 
        @client_server.puts("set test 65536 0 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the expiry value is greater than 2592000" do 
        @client_server.puts("set test 0 2592001 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when noreply parameter is incorrect" do 
        @client_server.puts("ser test 0 2592001 1 norep")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        command_get = CommandSet.new(@store ,command, @server_accepted)
        message = @client_server.gets.chop
        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    after(:each) do
        $store = nil
        @client_server.close
        @server.close
    end
    
end

