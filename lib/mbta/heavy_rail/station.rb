module MBTA
  module HeavyRail
    class Station
      attr_reader :line, :name
      attr_writer :platforms

      def initialize(line, name, platforms = [])
        @line = line
        @name = name
        @platforms = platforms
      end

      def inspect
        %("#{@name}")
      end

      def platforms(direction = nil)
        if (direction)
          self[direction]
        else
          @platforms
        end
      end

      def [](direction)
        @platforms.find { |platform| platform.direction == direction }
      end
    end
  end
end
