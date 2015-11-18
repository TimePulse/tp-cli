require 'spec_helper'

describe TpCommandLine::Config do
  describe "#load_config" do
    let :config_instance do
      cnfg = TpCommandLine::Config.new
      allow(cnfg).to receive(:file_set).and_return(file_set)
      cnfg
    end

    let :file_set do
      dbl = double("Valise::Set")
      allow(dbl).to receive(:contents).with("timepulse.yml").
                                       and_return(config_hash)
      dbl
    end


    context "with all necessary config information" do
      let :config_hash do
        {
          "timepulse_url" => "http://www.timepulse.io/activities",
          "project_id" => 2,
          "login" => "Logan Loggins",
          "authorization" => "KickOffYourSundayShoes"}
      end

      it "returns the config hash" do
        expect(config_instance.load_config).to eq(config_hash)
      end
    end

    context "with missing fields" do
      let :config_hash do
        {
          "timepulse_url" => "http://www.timepulse.io/activities",
          "authorization" => "KickOffYourSundayShoes"}
      end

      it "prints out an error message and exits" do
        expect do
          expect do
            config_instance.load_config
          end.to output("Missing necessary parameters: project_id, login").to_stdout
        end.to raise_error(SystemExit)
      end
    end
  end
end
