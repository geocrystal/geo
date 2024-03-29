module Geo
  struct Coord
    # Calculates initial and final bearings between two points using great-circle distance formulas
    def bearing(to : Geo::Coord, final = false) : Float64
      Geo::Bearing.bearing(lat, lng, to.lat, to.lng, final)
    end
  end
end
