
class Command

    def storage_commands_lenght(command)
        return [5,6].include? command.length 
    end

    def retrieval_commands_lenght(command)
        return command.length > 1
    end


end