require "./spec_helper"

describe Geo do
  context "DISTANCE_UNITS" do
    it do
      distance_units = {
        :centimeters,
        :centimetres,
        :degrees,
        :feet,
        :inches,
        :kilometers,
        :kilometres,
        :meters,
        :metres,
        :miles,
        :millimeters,
        :millimetres,
        :nautical_miles,
        :radians,
        :yards,
      }

      Geo::DISTANCE_UNITS.should eq(distance_units)
    end
  end
end
