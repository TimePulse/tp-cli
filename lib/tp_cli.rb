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
      necessary_params = ["url", "project_id", "login", "authorization"]
      home_config = File.join(Dir.home, ".timepulse.yml")

      # if file_in_home_directory
      #   if file_in_home_directory has necessary_params
      #     use those params, but check project_file for replacing (merging) its params

      #   else file_in_home_directory does not have necessary params
      #     use existing params, check project_file for inserting (mering?) missing params
      #   end
      # else file_in_home_directory does not exist
      #   use project_file params
      #     if project_file does not have all necessary params
      #       raise error/indicate to user they are missing a param
      # end

      # if file_in_home_directory exists
      #   if file_in_home_directory has necessary_params
      #     put in necessary_params
      #     if project_file exists
      #       if project file has necessary_params
      #         override params with project_file necessary_params
      #         request.run
      #       else
      #         puts "projectfile missing params"
              #end
      #     end
      #   request.run
      #   end
      # else file_in_home_directory does not exist
      #   if projectfile exists
      #     if projectfile has necessary_params
      #       put in necessary_params and request.run
      #     else
      #       puts "projectfile missing params"
      #     end
      #   end
      # end
#load file, then parse it and look for keys of hash
      hash1 = YAML.load(File.read(home_config))
      hash2 = YAML.load(File.read('config/.timepulse.yml'))

      if File.exists?(home_config)
        #try all instead of any
        if hash1.has_key?("project_id") || hash1.has_key?("login")
        # if File.readlines(home_config).grep(/project_id/).any?
        # if File.readlines(home_config).grep(/project_id/).any?
          # && necessary_params
          #TODO: make check for params, use next file, use enumerable grep?
          puts "necessary params are there"
          config1 = YAML.load_file(File.join(Dir.home, ".timepulse.yml"))
          url = config1['timepulse_url']
          project_id = config1['project_id']
          login = config1['login']
          authorization = config1['authorization']

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
          if File.exists?('config/.timepulse.yml')
            #need to figure out how to grep necessary params that have values only
            if hash2.has_key?("project_id") || hash2.has_key?("login")
            # if File.readlines('config/.timepulse.yml').grep(/project_id/).any?
              config2 = YAML.load_file('config/.timepulse.yml')
              url = config2['timepulse_url']
              project_id = config2['project_id'] if hash2.has_key?("project_id")
              login = config2['login']
              authorization = config2['authorization']
              config2.merge(config1)
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
            else
              puts "file 2 missing params"
            end
          end
        request.run
        end
      else
        puts "home file does not exist"
        if File.exists?('config/.timepulse.yml')
          if File.readlines('config/.timepulse.yml').grep(/#{necessary_params}/).all?
            config2 = YAML.load_file('config/.timepulse.yml')
            url = config2['timepulse_url']
            project_id = config2['project_id']
            login = config2['login']
            authorization = config2['authorization']

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
          else
            puts "file 2 does not have necessary params"
          end
        end
      end
      # elsif File.exists?('config/.timepulse.yml')
      #   config = YAML.load_file('config/.timepulse.yml')
      #   url = config['timepulse_url']
      #   project_id = config['project_id']
      #   login = config['login']
      #   authorization = config['authorization']

      #   request = Typhoeus::Request.new(
      #     url,
      #     method: :post,
      #     params: { activity: {
      #       description: description,
      #       project_id: project_id,
      #       source: "API"
      #       }
      #     },
      #     headers: { login: login, Authorization: authorization }
      #   )
      #   request.run
      # else
      #   puts "no file"
      # end

      # url = config['timepulse_url']
      # project_id = config['project_id']
      # login = config['login']
      # authorization = config['authorization']

      # request = Typhoeus::Request.new(
      #   url,
      #   method: :post,
      #   params: { activity: {
      #     description: description,
      #     project_id: project_id,
      #     source: "API"
      #     }
      #   },
      #   headers: { login: login, Authorization: authorization }
      # )
      # request.run

      # config = YAML.load_file('config/.timepulse.yml')
      # url = config['timepulse_url']
      # project_id = config['project_id']
      # login = config['login']
      # authorization = config['authorization']

      # request = Typhoeus::Request.new(
      #   url,
      #   method: :post,
      #   params: { activity: {
      #     description: description,
      #     project_id: project_id,
      #     source: "API"
      #     }
      #   },
      #   headers: { login: login, Authorization: authorization }
      # )
      # request.run
    end
  end
end