require 'sinatra'
require "sinatra/sse"

module Verisimilitude
  class App < Sinatra::Base
    include Sinatra::SSE

    get '/distribution' do
      sse_stream do |out|
        EM.add_periodic_timer(1) do
          out.push :event => "distribution", :data => `veritas distribution -etcdCluster=http://192.168.11.11:4001`
        end
      end
    end

  end
end
