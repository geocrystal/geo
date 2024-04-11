require "../spec_helper"
require "../../src/geo/distance"

describe Geo::Coord do
  london = Geo::Coord.new(51.500153, -0.126236)
  new_york = Geo::Coord.new(40.714268, -74.005974)
  point = Geo::Coord.new(39, -75)

  context "distance" do
    context "calculates distance (by haversine formula)" do
      it { london.distance(london).to_kilometers.should eq(0) }
      it { new_york.distance(london).to_kilometers.should eq(5570.482153929098) }
    end
  end

  context "destination" do
    context "Calculates the location of a destination point (by haversine formula)" do
      it { point.destination(5000, 90, :kilometers).should eq(Geo::Coord.new(26.440010707631124, -22.885355549364313)) }
    end
  end
end
