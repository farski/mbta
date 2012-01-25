module MBTA
  module HeavyRail
    class Trip
      attr_reader :line, :id
      attr_accessor :announcements

      def initialize(line, id)
        @line = line
        @id = id
        @announcements = []
      end
    end
  end
end
