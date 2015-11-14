require 'typhoeus'
require "tp_cli/version"
require 'yaml'
# require 'configclass' # Ask Anne about this

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
      config = TpCommandLine::Config.new.load_config
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
