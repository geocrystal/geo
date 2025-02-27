require "../spec_helper"

describe Geo::Coord do
  context "initialize" do
    context "is initialized by (lat, lng)" do
      c = Geo::Coord.new(50.004444, 36.231389)

      it { c.lat.should eq(50.004444) }
      it { c.lng.should eq(36.231389) }
    end
  end

  context "strfcoord" do
    context "renders components" do
      pos = Geo::Coord.new(50.004444, 36.231389)
      neg = Geo::Coord.new(-50.004444, -36.231389)

      it { pos.strfcoord("%latd").should eq("50") }
      it { neg.strfcoord("%latd").should eq("50") }
      it { neg.strfcoord("%latds").should eq("-50") }

      it { pos.strfcoord("%latm").should eq("0") }
      it { pos.strfcoord("%lats").should eq("16") }
      it { pos.strfcoord("%lath").should eq("N") }
      it { neg.strfcoord("%lath").should eq("S") }

      it { pos.strfcoord("%lat").should eq("%f" % pos.lat) }
      it { neg.strfcoord("%lat").should eq("%f" % neg.lat) }

      it { pos.strfcoord("%lngd").should eq("36") }
      it { neg.strfcoord("%lngd").should eq("36") }
      it { neg.strfcoord("%lngds").should eq("-36") }

      it { pos.strfcoord("%lngm").should eq("13") }
      it { pos.strfcoord("%lngs").should eq("53") }
      it { pos.strfcoord("%lngh").should eq("E") }
      it { neg.strfcoord("%lngh").should eq("W") }

      it { pos.strfcoord("%lng").should eq("%f" % pos.lng) }
      it { neg.strfcoord("%lng").should eq("%f" % neg.lng) }
    end

    context "understands flags and options" do
      pos = Geo::Coord.new(50.004444, 36.231389)
      neg = Geo::Coord.new(-50.004444, -36.231389)

      it { pos.strfcoord("%+latds").should eq("+50") }
      it { neg.strfcoord("%+latds").should eq("-50") }

      it { pos.strfcoord("%0.2lats").should eq("%0.2f" % pos.lats) }
      it { pos.strfcoord("%0.4lat").should eq("%0.4f" % pos.lat) }
      it { pos.strfcoord("%+0.4lat").should eq("%+0.4f" % pos.lat) }
      it { pos.strfcoord("%+lat").should eq("%+f" % pos.lat) }

      it { pos.strfcoord("%+lngds").should eq("+36") }
      it { neg.strfcoord("%+lngds").should eq("-36") }

      it { pos.strfcoord("%0.2lngs").should eq("%0.2f" % pos.lngs) }
      it { pos.strfcoord("%0.4lng").should eq("%0.4f" % pos.lng) }
      it { pos.strfcoord("%+0.4lng").should eq("%+0.4f" % pos.lng) }
    end

    context "just leaves unknown parts" do
      pos = Geo::Coord.new(50.004444, 36.231389)
      it { pos.strfcoord("%latd %foo").should eq("50 %foo") }
    end

    context "understands everyting at once" do
      pos = Geo::Coord.new(50.004444, 36.231389)

      it do
        pos.strfcoord(%{%latd %latm' %lats" %lath, %lngd %lngm' %lngs" %lngh})
          .should eq(%{50 0' 16" N, 36 13' 53" E})
      end
    end

    context "can carry" do
      pos = Geo::Coord.new(0.033333, 91.333333)

      it { pos.strfcoord("%latd %latm %lats, %lngd %lngm %lngs").should eq("0 2 0, 91 20 0") }
      it { pos.strfcoord("%latd %latm %0.2lats, %lngd %lngm %0.2lngs").should eq("0 2 0.00, 91 20 0.00") }
      it { pos.strfcoord("%latd %latm %0.3lats, %lngd %lngm %0.3lngs").should eq("0 1 59.999, 91 19 59.999") }
    end
  end

  context "geohash" do
    context "encode to geohash" do
      pos = Geo::Coord.new(50.004444, 36.231389)

      it { pos.geohash.should eq("ubcu2rnbuxcx") }
      it { pos.geohash(5).should eq("ubcu2") }
    end
  end

  context "to_s" do
    context "is convertible to string" do
      pos = Geo::Coord.new(50.004444, 36.231389)
      neg = Geo::Coord.new(-50.004444, -36.231389)

      it { pos.to_s.should eq(%{50°0'16"N 36°13'53"E}) }
      it { neg.to_s.should eq(%{50°0'16"S 36°13'53"W}) }
      it { "#{pos}".should eq(%{50°0'16"N 36°13'53"E}) }
    end
  end

  describe "#to_geojson" do
    coord = Geo::Coord.new(-15, 125)

    geojson = coord.to_geojson

    geojson.should be_a(GeoJSON::Coordinates)
  end

  describe "#to_wkt" do
    it "generates a Well Known Text format" do
      coord = Geo::Coord.new(50.004444, 36.231389)

      ewkt = coord.to_wkt

      ewkt.should eq "POINT(36.231389 50.004444)"
    end
  end

  describe "#to_wkb" do
    it "generates a Well Known Binary format" do
      coord = Geo::Coord.new(12, 34)

      ewkb = coord.to_wkb

      ewkb.should eq Bytes[
        0,                       # Big-Endian
        0, 0, 0, 1,              # POINT
        0, 0, 0, 34, 0, 0, 0, 0, # Longitude encoded as IEEE-754
        0, 0, 0, 12, 0, 0, 0, 0, # Latitude encoded as IEEE-754
      ]
    end
  end

  describe "#to_ewkt" do
    it "generates an Extended Well Known Text format" do
      coord = Geo::Coord.new(50.004444, 36.231389)

      ewkt = coord.to_ewkt

      ewkt.should eq "SRID=4326;POINT(36.231389 50.004444)"
    end
  end

  describe "#to_ewkb" do
    it "generates an Extended Well Known Binary format" do
      coord = Geo::Coord.new(12, 34)

      ewkb = coord.to_ewkb

      ewkb.should eq Bytes[
        0,                       # Big-Endian
        0, 0, 0, 1,              # POINT
        0, 0, 0, 34, 0, 0, 0, 0, # Longitude encoded as IEEE-754
        0, 0, 0, 12, 0, 0, 0, 0, # Latitude encoded as IEEE-754
        16, 140,                 # SRID 4326
      ]
    end
  end

  describe "comparisons" do
    describe "equality" do
      pos1 = Geo::Coord.new(45.3142533036254, -93.47527313511819)
      pos2 = Geo::Coord.new(45.3142533036254, -93.47527313511819)
      pos3 = Geo::Coord.new(45.31232182518015, -93.34893036168069)

      it { (pos1 == pos1).should be_truthy }
      it { (pos1 == pos2).should be_truthy }
      it { (pos1 == pos3).should be_falsey }
    end

    describe "lexicographical order" do
      pos1 = Geo::Coord.new(1.0, 2.0)
      pos2 = Geo::Coord.new(2.0, 1.0)

      pos3 = Geo::Coord.new(1.0, 1.0)
      pos4 = Geo::Coord.new(0.0, 0.0)
      pos5 = Geo::Coord.new(-1.0, -1.0)

      it { (pos1 < pos2).should be_truthy }
      it { (pos3 < pos1).should be_truthy }
      it { (pos3 < pos1).should be_truthy }

      it { pos4.between?(pos5, pos3).should be_truthy }
      it { pos4.between?(pos3, pos5).should be_truthy }
      it { pos1.between?(pos5, pos3).should be_falsey }

      it { [pos4, pos5, pos3].min.should eq(pos5) }
      it { [pos4, pos5, pos3].max.should eq(pos3) }
    end
  end
end
