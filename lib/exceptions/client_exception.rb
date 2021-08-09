class ClientException < StandardError
    def initialize(msg="Hubo un problema con los parametros del comando.")
        super
    end
end