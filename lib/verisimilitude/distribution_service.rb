require 'verisimilitude/distribution'
require 'verisimilitude/veritas_wrapper'

module Verisimilitude
  class DistributionService
    def initialize(veritas: default_veritas, etcd_cluster_endpoints:)
      @veritas = veritas
      @etcd_cluster_endpoints = etcd_cluster_endpoints
    end

    def fetch
      veritas_response = veritas.distribution(etcd_cluster_endpoints)
      return [] unless veritas_response.include? 'Distribution'
      cells = veritas_response.split("\n").slice(1..-1)
      cells.map { |cell_string| cell_string.split(':').
        map(&:strip) }.
        map { |name, apps|
          if apps.include? 'Empty'
            Distribution.new(name: name)
          else
            matches = /\e\[33m\e\[0m\e\[32m(•*)(\e\[0m\e\[90m(•*))?\e\[0m/.match(apps).to_a
            running = matches[1].length
            booting = matches[3].length
            Distribution.new(name: name, running: running, booting: booting)
          end
        }
    end

    private

    attr_reader :veritas, :etcd_cluster_endpoints

    def default_veritas
      VeritasWrapper.new
    end

  end
end
