require 'rspec'


  
it "does something.."
  conn = @server.accept
  # etc
end

describe SocketServer do 

    before(:each) do
        @socket_address = 'localhost'
        @socket_port = 2000
        @server = TCPServer.open(@socket_port)
        @server.start
        @client_server = TCPSocket.open(@socket_address, @socket_port)
        @client_server.start
    end

       
    it "should return the value" do 
        hw = HelloWorld.new 
        message = hw.say_hello 
        expect(message).to eq "Hello World!"
    end
       

    after(:each) do
        @client_server.stop
        @server.stop
    end
end

