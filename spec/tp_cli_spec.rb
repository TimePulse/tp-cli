require 'spec_helper'

describe TpCommandLine::ActivityTrack do

  describe '#determine_description' do

    let :activity_track do
      TpCommandLine::ActivityTrack.new(args)
    end

    context "when given no arguments" do
      let :args do
        []
      end

      it "raises ArgumentError" do
        expect do
          activity_track.determine_description(args)
        end.to raise_error(ArgumentError)
      end
    end

    context "when given the 'note' argument" do
      let :args do
        ["note", "Foo"]
      end

      it "returns second argument" do
        expect(activity_track.determine_description(args)).
          to eq("Foo")
      end
    end

    context "when given the 'cwd' argument" do
      let :args do
        ["cwd"]
      end

      it "sends an activity to the server" do
        expect(activity_track.determine_description(args)).
          to eq("Changed working directory")
      end

    end

    context "when given other arguments" do
      let :args do
        ["Bar", "Foo", "OMG", "SO", "MANY", "ARGS"]
      end

      it "raises ArgumentError" do
        expect do
          activity_track.determine_description(args)
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe "#send_to_timepulse" do
    let :config_data do
      {
        "timepulse_url" => "www.timepulse.io/activities",
        "project_id" => "2",
        "login" => "Logan Loggins",
        "authorization" => "AuthorizationToTheDangerZone"
        }
    end

    let :activity_track do
      TpCommandLine::ActivityTrack.new(["cwd"])
    end

    before :each do
      config_double = double("TpCommandLine::Config")
      allow(config_double).to receive(:load_config).and_return(config_data)
      allow(TpCommandLine::Config).to receive(:new).and_return(config_double)
      Typhoeus.stub(/timepulse.io/).and_return(response)
    end

    context "with valid data" do
      let :response do
        Typhoeus::Response.new(response_code: 200)
      end

      it "assigns the correct url to the request" do
        activity_track.send_to_timepulse

        expect(activity_track.request.base_url).to eq("www.timepulse.io/activities")
      end

      it "assigns the correct options to the request" do
        activity_track.send_to_timepulse
        options = activity_track.request.original_options
        activity_params = options[:params][:activity]
        # activity_params = options[:body][:activity]
        headers = options[:headers]

        expect(options[:method]).to eq(:post)
        expect(activity_params[:description]).to eq("Changed working directory")
        expect(activity_params[:project_id]).to eq("2")
        expect(activity_params[:source]).to eq("API")
        expect(headers[:login]).to eq("Logan Loggins")
        expect(headers[:Authorization]).to eq("AuthorizationToTheDangerZone")
      end

      it "receives a response" do
        activity_track.send_to_timepulse
        expect(activity_track.request.response).not_to be_nil
      end

      it "prints a successful response" do
        expect do
          activity_track.send_to_timepulse
        end.to output("\nThe activity was sent to TimePulse.\n").to_stdout
      end
    end

    context "with invalid authorization credentials" do
      let :response do
        Typhoeus::Response.new(response_code: 401)
      end

      it "prints a notification of error" do
        expect do
          activity_track.send_to_timepulse
        end.to output("\nThe TimePulse server was unable to authorize you. Check the API token in your timepulse.yml files.\n").to_stdout
      end
    end

    context "with invalid configuration data" do
      let :response do
        Typhoeus::Response.new(response_code: 422)
      end

      it "prints a notification of error" do
        expect do
          activity_track.send_to_timepulse
        end.to output("\nThere was an error saving to TimePulse. Please check the information in your timepulse.yml files.\n").to_stdout
      end
    end

    context "with server connectivity issues" do
      let :response do
        Typhoeus::Response.new(response_code: 0)
      end

      it "prints a notification of error" do
        expect do
          activity_track.send_to_timepulse
        end.to output("\nPlease check your internet connection and that the project site is not currently offline.\nCurl Error: #{response.return_code}\n").to_stdout
      end
      #need test for all other response codes, i.e. unexpected response
    end
  end
end
