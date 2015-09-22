require 'typhoeus'
require "tp_cli/version"

module TpCommandLine
  class ActivityTrack

    def initialize(args)
      @args = args
    end

    #determine user activity and user feedback or what to POST
    def det_activity
      if @args.empty?
        raise ArgumentError, '/specify action/'
        #puts "\n Please specify action: bin/tp_cli [note] or bin/tp_cli [cwd]"

      elsif @args[0] == "note" && @args[1].is_a?(String)
        post_to_TP(@args[1])

      else @args[0] == "cwd"
        post_to_TP("Changed working directory")
      end
    end
    #POST to create method in TP Activities controller; create an Activity in db
    def post_to_TP(description)
      request = Typhoeus::Request.new(
        "http://localhost:3000/activities",
        method: :post,
        params: { activity: {
          description: description,
          project_id: 1,
          source: "API"
          }
        },
        headers: { login: "admin", Authorization: "ZE06nDe8PJ4-2s8TFBYB" }
      )
      request.run
    end
  end
end