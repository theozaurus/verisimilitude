module Verisimilitude
  class Distribution
    def initialize(name:, running: 0, booting: 0)
      @name = name
      @running = running
      @booting = booting
    end

    def ==(another)
      self.class == another.class &&
      running == another.running &&
      booting == another.booting &&
      name == another.name
    end
    alias_method :eql?, :==

    attr_reader :running, :booting, :name
  end
end
