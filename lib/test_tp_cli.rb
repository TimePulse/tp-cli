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
    hash1.merge(hash2)

    necessary_params = ["timepulse_url", "project_id", "login", "authorization"]
    for p in necessary_params do |p|
      if p.exist? == false
        puts "#{p} is a missing and necessary parameter"
      end
    end


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