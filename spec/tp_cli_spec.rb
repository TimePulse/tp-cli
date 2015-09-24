require 'spec_helper'

describe TpCommandLine::ActivityTrack do
  subject { TpCommandLine::ActivityTrack.new }

  describe '#determine_activity' do

    #from JL: clean up with tracker built in a let
    it 'checks for cl arguments' do
      expect{ TpCommandLine::ActivityTrack.new([]).determine_activity }.to raise_error(/specify action/)
    end
    # Below works, but not ideal
    # it 'checks for cl arguments' do
    #   expect(`bin/tp_cli`).to eq("\n Please specify action: bin/tp_cli [note] or bin/tp_cli [cwd]\n")
    # end
  end
end