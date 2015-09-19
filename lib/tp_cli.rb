require 'typhoeus'
require "tp_cli/version"

module tp_cli
  class ActivityTrack
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

    if ARGV.empty?
      puts "\n Please specificy action: ./typhscript [note] or ./typhscript [cwd]"

    elsif ARGV[0] == "note" && ARGV[1].is_a?(String)
      post_to_TP(ARGV[1].to_s)

    else ARGV[0] == "cwd"
      post_to_TP("Changed working directory")

    end
  end
end