module Geo
  class Polygon
    getter coords
    @centroid : Geo::Coord? = nil

    def initialize(@coords : Array(Geo::Coord))
      # A Polygon must be 'closed', the last coord equal to the first coord
      # Append the first coord to the array to close the polygon
      @coords << @coords.first if @coords.first != @coords.last
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
      @centroid ||= calculate_centroid
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
