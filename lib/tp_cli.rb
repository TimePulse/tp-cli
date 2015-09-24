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

      config = YAML.load_file('config/.timepulse.yml')
      url = config['timepulse_url']
      project_id = config['project_id']
      login = config['login']
      authorization = config['authorization']

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