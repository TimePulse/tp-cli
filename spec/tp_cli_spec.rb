require 'spec_helper'

describe TpCommandLine::ActivityTrack do
  subject { TpCommandLine::ActivityTrack.new }

  describe '#det_activity' do

    # let(:input) { 'bin/tp_cli note ok' }
    # let(:output) { subject.det_activity }

    # it 'checks for cl arguments' do
    #   expect(output).to eq output

    # let(:input) { `bin/tp_cli` }
    # p `bin/tp_cli`
    # let(:output) { stdout }

    # it 'checks for cl arguments' do
    #   expect { subject.det_activity }.to output("Please specificy action: bin/tp_cli [note] or bin/tp_cli [cwd]").to_stdout

    # it 'checks for cl arguments' do
    #   expect { `bin/tp_cli` }.to output("\n Please specificy action: bin/tp_cli [note] or bin/tp_cli [cwd]").to_stdout
    # end
    #from JL:, with tracker built in a let
    it 'checks for cl arguments' do
      expect{ TpCommandLine::ActivityTrack.new([]).det_activity }.to raise_error(/specify action/)
    end
    #Below works, but not ideal
    # it 'checks for cl arguments' do
    #   expect(`bin/tp_cli`).to eq("\n Please specify action: bin/tp_cli [note] or bin/tp_cli [cwd]\n")
    # end
  end
end