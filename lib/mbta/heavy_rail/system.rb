require 'mbta/heavy_rail/line'
require 'mbta/heavy_rail/station'
require 'mbta/heavy_rail/platform'

module MBTA
  module HeavyRail
    module System
      class Map
        attr_reader :lines

        def initialize(lines = {})
          @lines = lines
        end
      end

      class Builder
        def initialize
          @data = ::CSV.read("../data/RealTimeHeavyRailKeys.csv", { headers: true })
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
end
