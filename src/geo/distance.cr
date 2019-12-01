require "haversine"

module Geo
  struct Coord
    # Calculates distance to `other`.
    # Haversine formula is used.
    def distance(other : Geo::Coord) : Haversine::Distance
      Haversine.distance(self.ll, other.ll)
    end
  end
end
