require 'json'

module Verisimilitude
  class DistributionsSerializer

    def to_json(distributions)
      JSON.generate(distributions.map { |d|
        {
          booting: d.booting,
          running: d.running,
          name:    d.name
        }
      })
    end

  end
end
