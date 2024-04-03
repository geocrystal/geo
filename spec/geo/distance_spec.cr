require "../spec_helper"
require "../../src/geo/distance"

describe Geo::Coord do
  london = Geo::Coord.new(51.500153, -0.126236)
  new_york = Geo::Coord.new(40.714268, -74.005974)

  context "distance" do
    context "calculates distance (by haversine formula)" do
      it { london.distance(london).to_kilometers.should eq(0) }
      it { new_york.distance(london).to_kilometers.should eq(5570.482153929098) }
    end
  end
end
