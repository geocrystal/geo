module Geo
  struct Coord
    def sun_times : SunTimes::SunTime
      SunTimes::SunTime.new(lat.to_f64, lng.to_f64)
    end

    def sunrise(date : Time, location : Time::Location? = nil) : Time
      sun_times.sunrise(date, location)
    end

    def sunrise?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.sunrise?(date, location)
    end

    def sunset(date : Time, location : Time::Location? = nil) : Time
      sun_times.sunset(date, location)
    end

    def sunset?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.sunset?(date, location)
    end

    def solar_noon(date : Time, location : Time::Location? = nil) : Time
      sun_times.solar_noon(date, location)
    end

    def daylight_length(date : Time, location : Time::Location? = nil) : Time::Span
      sun_times.daylight_length(date, location)
    end

    def sun_events(date : Time, location : Time::Location? = nil)
      sun_times.events(date, location)
    end

    def civil_dawn(date : Time, location : Time::Location? = nil) : Time
      sun_times.civil_dawn(date, location)
    end

    def civil_dawn?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.civil_dawn?(date, location)
    end

    def civil_dusk(date : Time, location : Time::Location? = nil) : Time
      sun_times.civil_dusk(date, location)
    end

    def civil_dusk?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.civil_dusk?(date, location)
    end

    def nautical_dawn(date : Time, location : Time::Location? = nil) : Time
      sun_times.nautical_dawn(date, location)
    end

    def nautical_dawn?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.nautical_dawn?(date, location)
    end

    def nautical_dusk(date : Time, location : Time::Location? = nil) : Time
      sun_times.nautical_dusk(date, location)
    end

    def nautical_dusk?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.nautical_dusk?(date, location)
    end

    def astronomical_dawn(date : Time, location : Time::Location? = nil) : Time
      sun_times.astronomical_dawn(date, location)
    end

    def astronomical_dawn?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.astronomical_dawn?(date, location)
    end

    def astronomical_dusk(date : Time, location : Time::Location? = nil) : Time
      sun_times.astronomical_dusk(date, location)
    end

    def astronomical_dusk?(date : Time, location : Time::Location? = nil) : Time?
      sun_times.astronomical_dusk?(date, location)
    end
  end
end
