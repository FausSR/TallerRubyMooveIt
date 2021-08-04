class ServerException < StandardError
    def initialize(msg="There was a problem with the server.")
      super
    end
end