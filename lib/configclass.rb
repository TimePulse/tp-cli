require "tp_cli/version"
require 'yaml'

module TpCommandLine
  class Config
      def load_file(file)
        if File.exists?(file)
          return YAML.load(File.read(file))
        else
          file = {}
        end
      end

      def load_config
        hash1 = load_file(File.join(Dir.home, ".timepulse.yml"))
        hash2 = load_file('config/.timepulse.yml')

        @config_hash = hash1.merge(hash2)

        missing_fields = ['timepulse_url', 'project_id', 'login',
                          'authorization'].find_all {|k| !@config_hash.keys.include? k}
        unless missing_fields.empty?
          exit "Missing necessary parameter/s: #{missing_fields.join(", ")}"
        end

        return @config_hash
      end
  end
end