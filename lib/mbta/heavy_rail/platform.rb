module MBTA
  module HeavyRail
    class Platform
      attr_reader :station, :direction, :key

      def initialize(station, direction, order, key)
        @station = station
        @direction = direction
        @order = order
        @key = key
      end

      def predictions
        station.line.trips.inject(Array.new) do |memo, trip|
          memo << trip[1].announcements.inject(Array.new) do |m, a|
            m << a if (self.key == a.platform.key && a.type == :prediction)
            m
          end
        end.flatten.compact.sort {|x, y| x.time <=> y.time }
      end
    end
  end
end
