module Rails
  class Application
    class Configuration

      def database_configuration
        require 'erb'

        case RbConfig::CONFIG['ruby_install_name']
          when 'ruby'
            YAML::load(ERB.new(IO.read('config/database_ruby.yml')).result)
          else
            YAML::load(ERB.new(IO.read("config/database.yml")).result)
        end
      end

    end
  end
end