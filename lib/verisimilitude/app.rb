require 'sinatra'
require "sinatra/sse"

require 'verisimilitude/distribution_service'
require 'verisimilitude/distributions_serializer'

module Verisimilitude
  class App < Sinatra::Base
    include Sinatra::SSE

    get '/distribution' do
      sse_stream do |out|
        EM.add_periodic_timer(1) do
          out.push :event => "distribution", :data => distribution_serializer.to_json(distributions)
        end
      end
    end

    private

    def distributions
      distribution_service.fetch
    end

    def distribution_service
      @distribution_service ||= DistributionService.new(etcd_cluster_endpoints: ['http://192.168.11.11:4001'])
    end

    def distribution_serializer
      @distribution_serializer ||= DistributionsSerializer.new
    end

  end
end
