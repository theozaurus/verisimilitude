require 'rspec/its'

require 'verisimilitude/distribution_service'

RSpec.describe Verisimilitude::DistributionService do

  let(:veritas) { double('veritas wrapper') }

  let(:etcd_cluster_endpoints) { ['bork', 'pork', 'mork'] }



  describe 'fetch' do
    let(:result_text) { '' }

    subject(:results) { described_class.new(veritas: veritas, etcd_cluster_endpoints: etcd_cluster_endpoints).fetch }

    before do
      allow(veritas).to receive(:distribution).and_return(result_text)
    end

    it 'gets data from etcd using veritas' do
      expect(veritas).to receive(:distribution).with(etcd_cluster_endpoints)
      results
    end

    its(:size) { is_expected.to eql(0) }

    context 'when 1 cell, booting 1' do
      let(:result_text) { "Distribution\n   cell_z1-0: [33m[0m[32m[0m[90m•[0m" }

      its(:size) { is_expected.to eql(1) }
      its([0]) { is_expected.to eql(Verisimilitude::Distribution.new(name: 'cell_z1-0', booting: 1)) }
    end

    context 'when 1 cell, running 3' do
      let(:result_text) { "Distribution\n   cell_z1-0: [33m[0m[32m•••[0m[90m[0m" }

      its(:size) { is_expected.to eql(1) }
      its([0]) { is_expected.to eql(Verisimilitude::Distribution.new(name: 'cell_z1-0', running: 3)) }
    end

    context 'when 1 cell, empty' do
      let(:result_text) { "Distribution\n   cell_z1-0: [91mEmpty[0m" }

      its(:size) { is_expected.to eql(1) }
      its([0]) { is_expected.to eql(Verisimilitude::Distribution.new(name: 'cell_z1-0')) }
    end

    context 'when 1 cell, running 1, booting 2' do
      let(:result_text) { "Distribution\n   cell_z1-0: [33m[0m[32m•[0m[90m••[0m" }

      its(:size) { is_expected.to eql(1) }
      its([0]) { is_expected.to eql(Verisimilitude::Distribution.new(name: 'cell_z1-0', running: 1, booting: 2)) }
    end

  end

end

