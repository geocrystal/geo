require "convex_hull"
require "geohash"
require "geo_bearing"
require "haversine"
require "ring_area"
require "sun_times"
require "geojson"
require "polygon_contains"
require "./geo/utils"
require "./geo/coord"
require "./geo/polygon"
require "./geo/distance"
require "./geo/sun_times"

module Geo
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  DISTANCE_UNITS = Haversine::FACTORS.keys
end
