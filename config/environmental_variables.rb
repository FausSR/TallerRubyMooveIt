require 'yaml'

class EnvironmentalVariables

    def define_variables

        content = YAML.load_file ('./config/local_env.yml')
        $ENV = content

    end

end

