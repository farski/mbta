require './mbta/heavy_rail/system'

module MBTA
  module HeavyRail
    include MBTA::HeavyRail::System

    BlueLine = MBTA::HeavyRail::System::MAP.lines['Blue']
    GreenLine = MBTA::HeavyRail::System::MAP.lines['Green']
    RedLine = MBTA::HeavyRail::System::MAP.lines['Red']
  end
end
