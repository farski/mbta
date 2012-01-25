require 'csv'

require './mbta/version'
require './mbta/heavy_rail'

module MBTA
  include MBTA::HeavyRail
end

p MBTA::BlueLine