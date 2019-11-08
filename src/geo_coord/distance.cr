require "haversine"

module Geo
  class Coord
    # Calculates distance to `other`.
    # Haversine formula is used.
    def distance(other : Geo::Coord) : Haversine::Distance
      Haversine.distance(self.lat, self.lng, other.lat, other.lng)
    end
  end
end
