require 'valise'
require 'yaml'

module TpCommandLine
  class Config
    def file_set
      Valise::Set.define do
        ro "config/"
        ro "~/.timepulse"
        ro "~/"
        ro "/usr/share/timepulse"
        ro "/etc/timepulse"

        handle "*.yml", :yaml, :hash_merge
        handle "*.yaml", :yaml, :hash_merge
      end
    end

    def load_config
      @config_hash = file_set.contents("timepulse.yml")

      missing_fields = ['timepulse_url', 'project_id', 'login',
                        'authorization'].find_all {|k| !@config_hash.keys.include? k}
      unless missing_fields.empty?
        exit "Missing necessary parameter/s: #{missing_fields.join(", ")}"
      end

      return @config_hash
    end
  end
end
