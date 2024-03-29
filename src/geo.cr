require "convex_hull"
require "geohash"
require "./geo/utils"
require "./geo/coord"
require "./geo/polygon"

module Geo
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end
