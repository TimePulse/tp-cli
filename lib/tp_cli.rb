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

    # #is there a way to do p1, p2, p3, p4 and insert into config_hash[#{p1}]?
    #     necessary_params = ["timepulse_url", "project_id", "login", "authorization"]


    #     # necessary_params.each do |p1, p2, p3, p4|
      if config_hash.include? 'timepulse_url'
        url = config_hash['timepulse_url']
      else
        puts "Missing necessary parameter: timepulse url"
      end
      if config_hash.include? 'project_id'
        project_id = config_hash['project_id']
      else
        puts "Missing necessary parameter: project id"
      end
      if config_hash.include? 'login'
        login = config_hash['login']
      else
        puts "Missing necessary parameter: login"
      end
      if config_hash.include? 'authorization'
        authorization = config_hash['authorization']
      else
        puts "Missing necessary parameter: authorization"
      end



        # end
        # necessary_params = ["timepulse_url", "project_id", "login", "authorization"]

        # for k, v in config_hash
        #   if config_hash.include? necessary_params
        #     url = config_hash['timepulse_url']
        #     project_id = config_hash['project_id']
        #     login = config_hash['login']
        #     authorization = config_hash['authorization']
        #   else
        #     puts "Missing necessary parameter: #{necessary_params}"
        #   end
        # end

        # # end


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