require 'spec_helper'

describe TpCommandLine::ActivityTrack do
  subject { TpCommandLine::ActivityTrack.new }

  describe '#det_activity' do

    # let(:input) { 'bin/tp_cli note ok' }
    # let(:output) { subject.det_activity }

    # it 'checks for cl arguments' do
    #   expect(output).to eq output

    let(:input) { 'bin/tp_cli' }
    let(:output) { subject.det_activity }

    it 'checks for cl arguments' do
      expect(output).to match "Please specificy action: bin/tp_cli [note] or bin/tp_cli [cwd]"
    end
  end
end