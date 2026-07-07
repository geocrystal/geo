module Geo
  struct Coord
    # Calculates distance to `other`.
    # Haversine formula is used.
    def distance(other : Geo::Coord) : Haversine::Distance
      Haversine.distance(ll, other.ll)
    end

    # Calculates the location of a destination point
    def destination(distance : Number, bearing : Number, unit : Symbol = :kilometers) : Geo::Coord
      point = Haversine.destination(ll, distance, bearing, unit)

      Geo::Coord.new(point[0], point[1])
    end
  end
end
