require 'sinatra'
require "sinatra/sse"

require 'verisimilitude/distribution_service'
require 'verisimilitude/distributions_serializer'

module Verisimilitude
  class App < Sinatra::Base

    set :public_folder, 'public'

    include Sinatra::SSE

    get '/' do
      send_file File.join(settings.public_folder, 'index.html')
    end

    get '/sse/distributions' do
      sse_stream do |out|
        EM.add_periodic_timer(1) do
          out.push :event => "distribution", :data => distribution_serializer.to_json(distributions)
        end
      end
    end

    get '/distributions' do
      distribution_serializer.to_json(distributions)
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
