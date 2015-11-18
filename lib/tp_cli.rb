require 'typhoeus'
require 'config'
require 'JSON'

module TpCommandLine
  class ActivityTrack

    attr_reader :request

    def initialize(args)
      description = determine_description(args)
      config_data = TpCommandLine::Config.new.load_config
      @server_url = config_data["timepulse_url"]
      @request_options = {
        method: :post,
        body: JSON.dump({
          activity: {
            description: description,
            project_id: config_data['project_id'],
            source: "API",
            time: Time.now.utc
          }
        }),
        headers: {
          login: config_data['login'],
          Authorization: config_data['authorization'],
          'Accept-Encoding' => 'application/json',
          'Content-Type' => 'application/json'
           }
        }
    end

    #determine user activity and user feedback or what to POST
    def determine_description(args)
      if args[0] == "note" && args[1].is_a?(String)
        args[1]
      elsif args[0] == "cwd"
        "Changed working directory"
      else
        raise ArgumentError
      end
    end

    def send_to_timepulse
      @request = Typhoeus::Request.new(@server_url, @request_options)

      begin
        @request.run
      rescue StandardError => err
        puts "\n Please check your internet connection and that the project site is not currently offline."
      end

      handle_response(@request.response)
    end

    def handle_response(response)
      if response.success?
        puts "The activity was sent to TimePulse."
      else
        puts "There was an error sending to TimePulse."
      end
    end

  end
end
