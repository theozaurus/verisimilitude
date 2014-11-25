require 'verisimilitude/distribution'

module Verisimilitude
  class DistributionServiceFake

    def fetch
      names(rand(3)).map { |n| Distribution.new(name: n, booting: booting, running: running) }
    end

    private

    def names(n)
      Array.new(n) { |n| "cell_z1-#{n}" }
    end

    def running
      rand(4)
    end

    def booting
      rand(7)
    end

  end
end
