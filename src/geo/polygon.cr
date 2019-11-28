module Geo
  # A `Polygon` is a fixed-size, immutable, stack-allocated sequence of `Geo::Coord`.
  # Coordinates are in lexicographical order.
  # Additionally, polygons form a closed loop and define a filled region.
  struct Polygon
    include Indexable(Geo::Coord)

    @centroid : Geo::Coord? = nil
    getter size : Int32

    def initialize(@coords : Array(Geo::Coord))
      @coords = order_coords

      # A polygon must be 'closed', the last coord equal to the first coord
      # Append the first coord to the array to close the polygon
      @coords << @coords.first
      @size = @coords.size
    end

    def coords
      @coords
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
      x = coord.lng
      y = coord.lat

      @coords.each do |p|
        yi = p.lat
        xi = p.lng
        yj = last_coord.lat
        xj = last_coord.lng
        if yi < y && yj >= y ||
           yj < y && yi >= y
          odd_nodes = !odd_nodes if xi + (y - yi) / (yj - yi) * (xj - xi) < x
        end

        last_coord = p
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
  end
end
