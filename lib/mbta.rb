require 'mbta/version'
require 'mbta/heavy_rail'

module MBTA
  include MBTA::HeavyRail

  BlueLine = MBTA::HeavyRail::System::MAP.lines['Blue']
  GreenLine = MBTA::HeavyRail::System::MAP.lines['Green']
  RedLine = MBTA::HeavyRail::System::MAP.lines['Red']
end
