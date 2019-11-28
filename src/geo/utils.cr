module Geo
  module Utils
    extend self

    # Orientation of ordered triplet (p, q, r)
    #
    # Orientation of an ordered triplet of points in the plane can be
    #
    # * counterclockwise
    # * clockwise
    # * colinear
    #
    # The function returns following values
    # 0 --> p, q and r are colinear
    # 1 --> Clockwise
    # 2 --> Counterclockwise
    def orientation(p : Geo::Coord, q : Geo::Coord, r : Geo::Coord)
      val = (q.lng - p.lng) * (r.lat - q.lat) -
            (q.lat - p.lat) * (r.lng - q.lng)

      return 0 if val == 0 # colinear
      val > 0 ? 1 : 2      # clockwise or counterclockwise
    end
  end
end
