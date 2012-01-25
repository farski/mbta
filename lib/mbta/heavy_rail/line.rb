module MBTA
  module HeavyRail
    class Line
      attr_reader :name, :color
      attr_writer :stations
      attr_accessor :trips

      def initialize(name, stations = {})
        @name = name
        @color = name.downcase.to_sym
        @stations = stations
        @trips = {}
      end

      def stations(name_or_direction = nil)
        case name_or_direction
          when String then self[name_or_direction]
          when Symbol then nil
          else @stations
        end
      end

      def [](name_or_key)
        case name_or_key
          when String then @stations.find { |station| station.name == name_or_key }
          when Symbol then platforms.find { |platform| platform.key == name_or_key }
        end
      end

      def platforms
        stations.inject(Array.new) { |memo, station| memo << station.platforms }.flatten
      end

      def parse_announcements(json)
        data = JSON.parse(json)
        _trips = data.inject(Array.new) { |memo, announcement| memo << announcement['Trip'].to_i }.uniq
        _trips.each do |trip|
          self.trips[trip] = MBTA::HeavyRail::Trip.new(self, trip)
        end

        data.each do |a|
          trip = self.trips[a['Trip'].to_i]
          time = Time.strptime(a['Time'], '%m/%d/%Y %H:%M:%S %p')
          platform = self[a['PlatformKey'].downcase.to_sym]

          announcement_type = case a['InformationType']
            when 'Arrived' then MBTA::HeavyRail::Announcements::Arrival
            when 'Predicted' then MBTA::HeavyRail::Announcements::Prediction
          end

          trip.announcements << announcement_type.new(trip, platform, time) if announcement_type
        end
      end
    end
  end
end
