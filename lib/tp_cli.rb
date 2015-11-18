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
      case response.response_code
      when 201
        puts "\nThe activity was sent to TimePulse."
      when 401
        puts "\nThe TimePulse server was unable to authorize you. Check the API token in your timepulse.yml files."
      when 422
        puts "\nThere was an error saving to TimePulse. Please check the information in your timepulse.yml files."
        if response.body
          puts "Rails Errors:"
          errors = JSON.parse(response.body)
          errors.each { |k, v| v.each { |vsub| puts "#{k} #{vsub}"}}
        end

      when 0
        puts "\nPlease check your internet connection and that the project site is not currently offline.\nCurl Error: #{response.return_code}"
      else
        puts "\nTimePulse returned an unexpected response: #{response.response_code}"
      end

      # puts response.return_code
      # puts response.response_code
      # puts response.body
      # puts response.headers
    end

  end
end
