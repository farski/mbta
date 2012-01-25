module MBTA
  module HeavyRail
    module Announcements
      class Base
        attr_reader :trip, :platform, :time

        def initialize(trip, platform, time)
          @trip = trip
          @platform = platform
          @time = time
        end

        def type
          self.class.name.split('::').last.downcase.to_sym
        end
      end
    end
  end
end
