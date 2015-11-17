require 'tp_cli'

RSpec.configure do |config|
  config.before :each do
    Typhoeus::Expectation.clear
  end
end
