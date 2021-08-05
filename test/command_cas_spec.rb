require 'rspec'
require 'socket'
require './lib/custom_hash'
require './lib/commands/command_cas'

describe CommandCas do 

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


    it "should return STORED when cas an existant key" do 
        
        @client_server.puts("cas test 1 0 5 1")
        @client_server.puts("test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        
        command_get = CommandCas.new(@store ,command, @server_accepted)       
        
        message = @client_server.gets.chop

        expect(message).to eq "STORED"
    end

    it "should return nothing when cas a existant key and have the noreply parameter" do 
        
        @client_server.puts("cas test 1 0 5 1 noreply")
        @client_server.puts("test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        
        @server_accepted.puts("Message to confirm that there is no response.")
        message = @client_server.gets.chop

        expect(message).to eq "Message to confirm that there is no response."
    end

    it "should return NOT_FOUND when cas a nonexistent key and use the parameter noreply" do 
        
        @client_server.puts("cas nonexistent_key 1 0 5 1 noreply")
        @client_server.puts("test3")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        
        command_get = CommandCas.new(@store ,command, @server_accepted)  
        
        message = @client_server.gets.chop

        expect(message).to eq "NOT_FOUND"
    end

    it "should return NOT_FOUND when cas a nonexistent key" do 
        
        @client_server.puts("cas nonexistent_key 1 0 5 1")
        @client_server.puts("test3")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        
        command_get = CommandCas.new(@store ,command, @server_accepted)       
        
        message = @client_server.gets.chop

        expect(message).to eq "NOT_FOUND"
    end

    it "should return CLIENT_ERROR when the command only has one parameter" do 
        
        @client_server.puts("cas")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandCas.new(@store ,command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command only has two parameters" do 
        
        @client_server.puts("cas test")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandCas.new(@store ,command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command only has three parameters" do 
        @client_server.puts("cas test 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandCas.new(@store ,command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command only has four parameters" do 
        
        @client_server.puts("cas test 1 0")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandCas.new(@store ,command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the command only has five parameters" do 
        
        @client_server.puts("cas test 1 0 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandCas.new(@store ,command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the key has more than 250 characters" do 
        key = rand(36**251).to_s(36)
        @client_server.puts("cas #{key} 1 0 5 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        
        command_get = CommandCas.new(@store ,command, @server_accepted)       
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return STORED when cas a existant key with 250 characters" do 
        key = rand(36**250).to_s(36)
        @store.set("#{key}", 'test', 0, 1, 4, 1)
        @client_server.puts("cas #{key} 1 0 5 1")
        @client_server.puts("test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        
        command_get = CommandCas.new(@store ,command, @server_accepted)       
        
        message = @client_server.gets.chop

        expect(message).to eq "STORED"
    end

    it "should return NOT_FOUND when cas a nonexistent key with 250 characters" do 
        key = rand(36**250).to_s(36)
        @client_server.puts("cas #{key} 1 0 5 1")
        @client_server.puts("test1")
        line = @server_accepted.gets.chop
        command = line.split(" ")
        
        command_get = CommandCas.new(@store ,command, @server_accepted)       
        
        message = @client_server.gets.chop

        expect(message).to eq "NOT_FOUND"
    end

    it "should return CLIENT_ERROR when the flag value is greater than 65535" do 
        
        @client_server.puts("cas test 65536 0 1 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandCas.new(@store ,command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    it "should return CLIENT_ERROR when the expiry value is greater than 2592001" do 
        
        @client_server.puts("cas test 65536 0 1")
        line = @server_accepted.gets.chop
        command = line.split(" ")

        command_get = CommandCas.new(@store ,command, @server_accepted)
        
        message = @client_server.gets.chop

        expect(message).to eq "CLIENT_ERROR Hubo un problema con los parametros del comando."
    end

    after(:each) do
        $store = nil
        @client_server.close
        @server.close
    end
end

