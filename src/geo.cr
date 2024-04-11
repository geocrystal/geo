require "convex_hull"
require "geohash"
require "geo_bearing"
require "haversine"
require "./geo/utils"
require "./geo/coord"
require "./geo/polygon"
require "./geo/distance"

module Geo
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  DISTANCE_UNITS = Haversine::FACTORS.keys
end
