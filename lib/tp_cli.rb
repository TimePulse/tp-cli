require 'typhoeus'
require "tp_cli/version"
require 'yaml'

module TpCommandLine
  class ActivityTrack

    def initialize(args)
      @args = args
    end

    #determine user activity and user feedback or what to POST
    def determine_activity
      if @args.empty?
        raise ArgumentError, '/specify action/'

      elsif @args[0] == "note" && @args[1].is_a?(String)
        record_activity_in_TP(@args[1])

      else @args[0] == "cwd"
        record_activity_in_TP("Changed working directory")
      end
    end

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

      config_hash = hash1.merge(hash2)

      missing_fields = ['timepulse_url', 'project_id', 'login', 'authorization'].find_all {|k| !config_hash.keys.include? k}
      unless missing_fields.empty?
        exit "Missing necessary parameter/s: #{missing_fields.join(", ")}"
      end

      return config_hash
    end

    #POST to create method in TP Activities controller; create an Activity in db
    def record_activity_in_TP(description)
      config = load_config
      request = Typhoeus::Request.new(
        config['timepulse_url'],
        method: :post,
        params: { activity: {
          description: description,
          project_id: config['project_id'],
          source: "API"
          }
        },
        headers: { login: config['login'], Authorization: config['authorization'] }
      )

      begin
        request.run
      rescue StandardError => err
        puts "\n Please check your internet connection and that the project site is not currently offline."
      end
    end
  end
end