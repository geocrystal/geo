require "./spec_helper"

describe Geo::Coord do
  context "initialize" do
    it "is initialized by (lat, lng)" do
      c = Geo::Coord.new(50.004444, 36.231389)

      c.lat.should eq(50.004444)
      c.lng.should eq(36.231389)
    end
  end

  context "strfcoord" do
    it "renders components" do
      pos = Geo::Coord.new(50.004444, 36.231389)
      neg = Geo::Coord.new(-50.004444, -36.231389)

      pos.strfcoord("%latd").should eq("50")
      neg.strfcoord("%latd").should eq("50")
      neg.strfcoord("%latds").should eq("-50")

      pos.strfcoord("%latm").should eq("0")
      pos.strfcoord("%lats").should eq("16")
      pos.strfcoord("%lath").should eq("N")
      neg.strfcoord("%lath").should eq("S")

      pos.strfcoord("%lat").should eq("%f" % pos.lat)
      neg.strfcoord("%lat").should eq("%f" % neg.lat)

      pos.strfcoord("%lngd").should eq("36")
      neg.strfcoord("%lngd").should eq("36")
      neg.strfcoord("%lngds").should eq("-36")

      pos.strfcoord("%lngm").should eq("13")
      pos.strfcoord("%lngs").should eq("53")
      pos.strfcoord("%lngh").should eq("E")
      neg.strfcoord("%lngh").should eq("W")

      pos.strfcoord("%lng").should eq("%f" % pos.lng)
      neg.strfcoord("%lng").should eq("%f" % neg.lng)
    end

    it "just leaves unknown parts" do
      pos = Geo::Coord.new(50.004444, 36.231389)
      pos.strfcoord("%latd %foo").should eq("50 %foo")
    end

    it "understands everyting at once" do
      pos = Geo::Coord.new(50.004444, 36.231389)

      pos.strfcoord(%{%latd %latm' %lats" %lath, %lngd %lngm' %lngs" %lngh})
        .should eq(%{50 0' 16" N, 36 13' 53" E})
    end

    it "can carry" do
      pos = Geo::Coord.new(0.033333, 91.333333)

      pos.strfcoord("%latd %latm %lats, %lngd %lngm %lngs").should eq("0 2 0, 91 20 0")
      pos.strfcoord("%latd %latm %0.2lats, %lngd %lngm %0.2lngs").should eq("0 2 0.00, 91 20 0.00")
      pos.strfcoord("%latd %latm %0.3lats, %lngd %lngm %0.3lngs").should eq("0 1 59.999, 91 19 59.999")
    end
  end

  context "to_s" do
    it "is convertible to string" do
      c = Geo::Coord.new(50.004444, 36.231389)
      c.to_s.should eq(%{50°0'16"N 36°13'53"E})
      c.to_s(dms: false).should eq("50.004444,36.231389")

      c = Geo::Coord.new(-50.004444, -36.231389)
      c.to_s.should eq(%{50°0'16"S 36°13'53"W})
      c.to_s(dms: false).should eq("-50.004444,-36.231389")
    end
  end
end
