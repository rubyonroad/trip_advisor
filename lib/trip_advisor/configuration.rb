module TripAdvisor
  module Configuration
    attr_accessor :key

    def configure
      yield self
    end
  end
end
