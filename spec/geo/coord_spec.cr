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

  context "to_s" do
    context "is convertible to string" do
      pos = Geo::Coord.new(50.004444, 36.231389)
      neg = Geo::Coord.new(-50.004444, -36.231389)

      it { pos.to_s.should eq(%{50°0'16"N 36°13'53"E}) }
      it { pos.to_s(dms: false).should eq("50.004444,36.231389") }

      it { neg.to_s.should eq(%{50°0'16"S 36°13'53"W}) }
      it { neg.to_s(dms: false).should eq("-50.004444,-36.231389") }
    end
  end

  describe "equality comparisons" do
    pos1 = Geo::Coord.new(45.3142533036254, -93.47527313511819)
    pos2 = Geo::Coord.new(45.31232182518015, -93.34893036168069)

    it {(pos1 == pos1).should be_truthy}
    it {(pos1 == pos2).should be_falsey}
  end
end
