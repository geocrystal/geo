require "../spec_helper"
require "../../src/geo/bearing.cr"

describe Geo::Coord do
  point_a = Geo::Coord.new(48.8566, 2.3522)   # Paris
  point_b = Geo::Coord.new(40.7128, -74.0060) # New York

  context "bearing" do
    # Checked on https://www.movable-type.co.uk/scripts/latlong.html
    context "calculates initial bearing" do
      it { point_a.bearing(point_b).should eq(291.7938627483058) }
    end

    context "calculates final bearing" do
      it { point_a.bearing(point_b, true).should eq(233.70448129781204) }
    end
  end
end
