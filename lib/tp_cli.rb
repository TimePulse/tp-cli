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

    #POST to create method in TP Activities controller; create an Activity in db
    def record_activity_in_TP(description)
      home_config = File.join(Dir.home, ".timepulse.yml")

      hash1 = YAML.load(File.read(home_config))
      hash2 = YAML.load(File.read('config/.timepulse.yml'))

      if File.exists?(home_config) == false
        hash1 = {}
      end
      if File.exists?('config/.timepulse.yml') == false
        hash2 = {}
      end
      if File.exists?(home_config) && File.exists?('config/.timepulse.yml')
        config_hash = hash1.merge(hash2)

      missing_fields = ['timepulse_url', 'project_id', 'login', 'authorization'].find_all {|k| !config_hash.keys.include? k}
      if missing_fields.empty?
        url = config_hash['timepulse_url']
        project_id = config_hash['project_id']
        login = config_hash['login']
        authorization = config_hash['authorization']
      else
        puts "Missing necessary parameter/s: #{missing_fields.join(", ")}"
      end

      request = Typhoeus::Request.new(
        url,
        method: :post,
        params: { activity: {
          description: description,
          project_id: project_id,
          source: "API"
          }
        },
        headers: { login: login, Authorization: authorization }
      )

      request.run
      end
    end
  end
end