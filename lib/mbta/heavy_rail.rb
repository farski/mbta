require './mbta/heavy_rail/system'

module MBTA
  module HeavyRail
    include MBTA::HeavyRail::System

    BlueLine = MBTA::HeavyRail::System::MAP.lines['Blue']
    OrangeLine = MBTA::HeavyRail::System::MAP.lines['Orange']
    RedLine = MBTA::HeavyRail::System::MAP.lines['Red']
  end
end
