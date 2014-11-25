require 'verisimilitude/distribution'

RSpec.describe Verisimilitude::Distribution do
  describe '#== & #eql' do
    let(:conf_a) { {running: 1, booting: 0, name: 'Frank'} }
    let(:conf_b) { {running: 1, booting: 1, name: 'Frank'} }

    let(:dis_1a) { described_class.new(conf_a) }
    let(:dis_2a) { described_class.new(conf_a) }
    let(:dis_3b) { described_class.new(conf_b) }

    let(:ran_4a) { double('random object', conf_a) }

    it 'works like a value object' do
      expect(dis_1a).to eq(dis_2a)
      expect(dis_1a).to eql(dis_2a)

      expect(dis_1a).to_not eq(dis_3b)
      expect(dis_1a).to_not eql(dis_3b)

      expect(dis_1a).to_not eq(ran_4a)
      expect(dis_1a).to_not eql(ran_4a)
    end
  end
end
