class ServerException < StandardError
    def initialize(msg="Hubo un problema con el servidor.")
        super
    end
end