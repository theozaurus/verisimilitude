require 'json'

require 'verisimilitude/distribution'
require 'verisimilitude/distributions_serializer'


RSpec.describe Verisimilitude::DistributionsSerializer do

  describe '#to_json' do

    let(:distribution) { Verisimilitude::Distribution.new(name: 'Frank', running: 1, booting: 2) }

    subject(:serialized) { described_class.new.to_json([distribution]) }

    it 'makes the json' do
      expect(JSON.parse(serialized)).to eq([{'name' => 'Frank', 'running' => 1, 'booting' => 2}])
    end

  end

end
