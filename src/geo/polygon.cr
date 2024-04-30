module Geo
  # A `Polygon` is a fixed-size, immutable, stack-allocated sequence of `Geo::Coord`.
  # Coordinates are in lexicographical order.
  # Additionally, polygons form a closed loop and define a filled region.
  struct Polygon
    include Indexable(Geo::Coord)

    @centroid : Geo::Coord? = nil
    getter size : Int32

    def initialize(@coords : Array(Geo::Coord), convex_hull = false)
      if convex_hull
        @coords = make_convex_hull(@coords)
      end

      @coords = order_coords

      # A polygon must be 'closed', the last coord equal to the first coord
      # Append the first coord to the array to close the polygon
      @coords << @coords.first
      @size = @coords.size
    end

    def coords
      @coords
    end

    # Return the approximate signed geodesic area of the polygon.
    def area : RingArea::Area
      coordinates = @coords.map { |coord| [coord.lng, coord.lat] }

      RingArea.ring_area(coordinates)
    end

    # Order coords in lexicographical order.
    # Starts from its bottom-most point in counterclockwise order.
    # Returns "not-closed" array of coordinates.
    private def order_coords
      ordered_coords = @coords

      min = @coords.min

      if min_idx = @coords.index(min)
        ordered_coords =
          if @coords.first == @coords.last
            @coords[...-1].rotate(min_idx)
          else
            @coords.rotate(min_idx)
          end
      end

      clockwise? ? ordered_coords.rotate.reverse : ordered_coords
    end

    private def clockwise?
      p1 = @coords[0]
      p2 = @coords[1]
      p3 = @coords[-2]

      Geo::Utils.orientation(p1, p2, p3) == 1 ? true : false
    end

    def contains?(coord : Geo::Coord) : Bool
      last_coord = @coords.last
      odd_nodes = false
      y, x = coord.ll

      @coords.each do |iter_coord|
        yi, xi = iter_coord.ll
        yj, xj = last_coord.ll

        if yi < y && yj >= y ||
           yj < y && yi >= y
          odd_nodes = !odd_nodes if xi + (y - yi) / (yj - yi) * (xj - xi) < x
        end

        last_coord = iter_coord
      end

      odd_nodes
    end

    def centroid : Geo::Coord
      # A polygon is static and can not be updated with new coords, as a result
      # calculate the centroid once and store it when requested.
      @centroid ||= calculate_centroid
    end

    def unsafe_fetch(index : Int)
      @coords[index]
    end

    def ==(other : Geo::Polygon) : Bool
      min_size = Math.min(size, other.size)

      0.upto(min_size - 1) do |i|
        return false unless self[i] == other[i]
      end

      size == other.size
    end

    def to_geojson : GeoJSON::Polygon
      coordinates = @coords.map { |coord| GeoJSON::Coordinates.new(coord.lng.to_f64, coord.lat.to_f64) }

      GeoJSON::Polygon.new([coordinates])
    end

    private def calculate_centroid : Geo::Coord
      centroid_lat = 0.0
      centroid_lng = 0.0
      signed_area = 0.0

      # Iterate over each element in the list but the last item as it's
      # calculated by the i+1 logic
      @coords[...-1].each_index do |i|
        x0 = @coords[i].lat
        y0 = @coords[i].lng
        x1 = @coords[i + 1].lat
        y1 = @coords[i + 1].lng
        a = (x0 * y1) - (x1 * y0)
        signed_area += a
        centroid_lat += (x0 + x1) * a
        centroid_lng += (y0 + y1) * a
      end

      signed_area *= 0.5
      centroid_lat /= (6.0 * signed_area)
      centroid_lng /= (6.0 * signed_area)

      Geo::Coord.new(centroid_lat, centroid_lng)
    end

    # Computation of convex hulls of a finite point set
    private def make_convex_hull(coords : Array(Geo::Coord))
      points = @coords.map { |coord| {coord.lat, coord.lng} }
      convex_hull = ConvexHull::GrahamScan.new(points)
      hull = convex_hull.to_a

      hull.map { |point| Geo::Coord.new(point.x.as(Float32 | Float64), point.y.as(Float32 | Float64)) }
    end
  end
end
