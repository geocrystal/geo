require "../spec_helper"

describe Geo::Coord do
  describe "#sun_times" do
    it "returns a SunTimes calculator for the coord" do
      coord = Geo::Coord.new(49.8419, 24.0311)
      sun = coord.sun_times

      sun.should be_a(SunTimes::SunTime)
      sun.latitude.should eq(49.8419)
      sun.longitude.should eq(24.0311)
    end
  end

  describe "sun time helpers" do
    coord = Geo::Coord.new(51.5, -0.13)
    london = Time::Location.load("Europe/London")
    date = Time.local(2025, 11, 5, location: london)
    sun = SunTimes::SunTime.new(51.5, -0.13)

    it { coord.sunrise(date, london).should eq(sun.sunrise(date, london)) }
    it { coord.sunrise?(date, london).should eq(sun.sunrise?(date, london)) }
    it { coord.sunset(date, london).should eq(sun.sunset(date, london)) }
    it { coord.sunset?(date, london).should eq(sun.sunset?(date, london)) }
    it { coord.solar_noon(date, london).should eq(sun.solar_noon(date, london)) }
    it { coord.daylight_length(date, london).should eq(sun.daylight_length(date, london)) }
    it { coord.sun_events(date, london).should eq(sun.events(date, london)) }
    it { coord.civil_dawn(date, london).should eq(sun.civil_dawn(date, london)) }
    it { coord.civil_dawn?(date, london).should eq(sun.civil_dawn?(date, london)) }
    it { coord.civil_dusk(date, london).should eq(sun.civil_dusk(date, london)) }
    it { coord.civil_dusk?(date, london).should eq(sun.civil_dusk?(date, london)) }
    it { coord.nautical_dawn(date, london).should eq(sun.nautical_dawn(date, london)) }
    it { coord.nautical_dawn?(date, london).should eq(sun.nautical_dawn?(date, london)) }
    it { coord.nautical_dusk(date, london).should eq(sun.nautical_dusk(date, london)) }
    it { coord.nautical_dusk?(date, london).should eq(sun.nautical_dusk?(date, london)) }
    it { coord.astronomical_dawn(date, london).should eq(sun.astronomical_dawn(date, london)) }
    it { coord.astronomical_dawn?(date, london).should eq(sun.astronomical_dawn?(date, london)) }
    it { coord.astronomical_dusk(date, london).should eq(sun.astronomical_dusk(date, london)) }
    it { coord.astronomical_dusk?(date, london).should eq(sun.astronomical_dusk?(date, london)) }
  end

  describe "polar dates" do
    coord = Geo::Coord.new(85, 0)
    utc = Time::Location.load("UTC")
    date = Time.local(2025, 12, 21, location: utc)

    it { coord.sunrise?(date, utc).should be_nil }

    it "keeps the raising behavior from sun_times" do
      expect_raises(SunTimes::CalculationError, "No sunrise occurs on this date for this location") do
        coord.sunrise(date, utc)
      end
    end
  end
end
