require 'httparty'
require 'json'
require 'csv'
require 'pp'

require "mbta/version"

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

      class Prediction < Base
      end

      class Arrival < Base
      end
    end

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

    class Trip
      attr_reader :line, :id
      attr_accessor :announcements

      def initialize(line, id)
        @line = line
        @id = id
        @announcements = []
      end
    end

    class Station
      attr_reader :line, :name
      attr_writer :platforms

      def initialize(line, name, platforms = [])
        @line = line
        @name = name
        @platforms = platforms
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

    module System
      class Map
        attr_reader :lines

        def initialize(lines = {})
          @lines = lines
        end
      end

      class Builder
        def initialize
          @data = CSV.read("../data/RealTimeHeavyRailKeys.csv", { headers: true })
        end

        def map
          data = @data
          line_names = data.inject(Array.new) {|memo, platform| memo.push(platform['Line']) }.uniq
          lines = line_names.map{|name| MBTA::HeavyRail::Line.new(name) }

          lines.each do |line|
            platforms = data.select {|row| row['Line'] == line.name }
            station_names = platforms.inject(Array.new) {|memo, platform| memo.push(platform['StationName']) }.uniq
            line.stations = station_names.map {|name| MBTA::HeavyRail::Station.new(line, name.capitalize) }

            line.stations.each do |station|
              data.select{|row| row['StationName'].capitalize == station.name }.each do |row|
                direction = case row['Direction']
                  when 'NB' then :northbound
                  when 'SB' then :southbound
                  when 'EB' then :eastbound
                  when 'WB' then :westbound
                end
                key = row['PlatformKey'].downcase.to_sym
                station.platforms.push(MBTA::HeavyRail::Platform.new(station, direction, row['PlatformOrder'], key))
              end
            end
          end

          _lines = lines.inject(Hash.new){|lines, line| lines[line.name] = line; lines }

          map = MBTA::HeavyRail::System::Map.new(_lines)
          return map
        end
      end

      MAP = Builder.new.map
    end
  end

  BlueLine = MBTA::HeavyRail::System::MAP.lines['Blue']
  GreenLine = MBTA::HeavyRail::System::MAP.lines['Green']
  RedLine = MBTA::HeavyRail::System::MAP.lines['Red']
end
