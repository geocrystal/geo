module Geo
  class Coord
    VERSION = "0.2.2"

    getter :lat
    getter :lng

    INTFLAGS    = /\+?/
    FLOATUFLAGS = /0\.\d+/
    FLOATFLAGS  = /\+?#{FLOATUFLAGS}?/

    DIRECTIVES = {
      # Latitude
      /%(#{FLOATUFLAGS})?lats/ => ->(m : Regex::MatchData) { "%<lats>#{m[1]? || "0."}f" },
      "%latm"                  => "%<latm>i",
      /%(#{INTFLAGS})?latds/   => ->(m : Regex::MatchData) { "%<latds>#{m[1]}i" },
      "%latd"                  => "%<latd>i",
      "%lath"                  => "%<lath>s",
      /%(#{FLOATFLAGS})?lat/   => ->(m : Regex::MatchData) { "%<lat>#{m[1]}f" },
      # Longitude
      /%(#{FLOATUFLAGS})?lngs/ => ->(m : Regex::MatchData) { "%<lngs>#{m[1]? || "0."}f" },
      "%lngm"                  => "%<lngm>i",
      /%(#{INTFLAGS})?lngds/   => ->(m : Regex::MatchData) { "%<lngds>#{m[1]}i" },
      "%lngd"                  => "%<lngd>i",
      "%lngh"                  => "%<lngh>s",
      /%(#{FLOATFLAGS})?lng/   => ->(m : Regex::MatchData) { "%<lng>#{m[1]}f" },
    }

    def initialize(@lat : Float32 | Float64, @lng : Float32 | Float64)
    end

    # Returns latitude degrees
    def latd : Int32
      lat.abs.to_i
    end

    # Returns latitude minutes
    def latm : Int32
      (lat.abs * 60).to_i % 60
    end

    # Returns latitude seconds
    def lats : Float32 | Float64
      (lat.abs * 3600) % 60
    end

    # Returns latitude hemisphere
    def lath : String
      lat > 0 ? "N" : "S"
    end

    # Returns longitude degrees
    def lngd : Int32
      lng.abs.to_i
    end

    # Returns longitude minutes
    def lngm : Int32
      (lng.abs * 60).to_i % 60
    end

    # Returns longitude seconds
    def lngs : Float32 | Float64
      (lng.abs * 3600) % 60
    end

    # Returns longitude hemisphere
    def lngh : String
      lng > 0 ? "E" : "W"
    end

    def latds
      lat.to_i
    end

    def lngds
      lng.to_i
    end

    # Formats coordinates according to directives in `formatstr`.
    #
    # Each directive starts with `%` and can contain some modifiers before its name.
    #
    # Acceptable modifiers:
    # - unsigned integers: none;
    # - signed integers: `+` for mandatory sign printing;
    # - floats: same as integers and number of digits modifier, like `0.3`.
    #
    # List of directives:
    #
    # - `%lat`   - Full latitude, floating point, signed
    # - `%latds` - Latitude degrees, integer, signed
    # - `%latd`  - Latitude degrees, integer, unsigned
    # - `%latm`  - Latitude minutes, integer, unsigned
    # - `%lats`  - Latitude seconds, floating point, unsigned
    # - `%lath`  - Latitude hemisphere, "N" or "S"
    # - `%lng`   - Full longitude, floating point, signed
    # - `%lngds` - Longitude degrees, integer, signed
    # - `%lngd`  - Longitude degrees, integer, unsigned
    # - `%lngm`  - Longitude minutes, integer, unsigned
    # - `lngs`   - Longitude seconds, floating point, unsigned
    # - `%lngh`` - Longitude hemisphere, "E" or "W"
    #
    # Examples:
    #
    # ```
    # g = Geo::Coord.new(50.004444, 36.231389)
    # g.strfcoord('%+lat, %+lng')
    # # => "+50.004444, +36.231389"
    # g.strfcoord("%latd°%latm'%lath -- %lngd°%lngm'%lngh")
    # # => "50°0'N -- 36°13'E"
    # ```
    #
    # `strfcoord` handles seconds rounding implicitly:
    #
    # ```
    # pos = Geo::Coord.new(0.033333, 91.333333)
    # pos.strfcoord('%latd %latm %0.5lats') # => "0 1 59.99880"
    # pos.strfcoord('%latd %latm %lats')  # => "0 2 0"
    # ```
    def strfcoord(formatstr)
      h = full_hash

      DIRECTIVES.reduce(formatstr) do |memo, (from, to)|
        memo.gsub(from) do
          to = to.call($~) if to.is_a?(Proc)

          res = to % h

          if tmp = guard_seconds(to, res)
            res, carrymin = tmp

            unless carrymin.empty?
              if h[carrymin].is_a?(Int32)
                tmp = h[carrymin].as(Int32)
                h[carrymin] = tmp + 1
              end
            end
          end

          res
        end
      end
    end

    # Returns a string representing coordinates.
    #
    # ```
    # g.to_s             # => "50°0'16\"N 36°13'53\"E"
    # g.to_s(dms: false) # => "50.004444,36.231389"
    # ```
    def to_s(dms : Bool = true)
      format = dms ? %{%latd°%latm'%lats"%lath %lngd°%lngm'%lngs"%lngh} : "%lat,%lng"
      strfcoord(format)
    end

    private def guard_seconds(pattern : String, result : String) : Array(String)?
      if m = pattern.match(/<(lat|lng)s>/)
        return [result, ""] unless m && result.starts_with?("60")
        carry = "#{m[1]}m"
        [pattern % {"lats" => 0, "lngs" => 0}, carry]
      end
    end

    private def full_hash : Hash(String, Int32 | Float32 | Float64 | String)
      {
        # Latitude
        "latd"  => latd,
        "latds" => latds,
        "latm"  => latm,
        "lats"  => lats,
        "lath"  => lath,
        "lat"   => lat,
        # Longitude
        "lngd"  => lngd,
        "lngds" => lngds,
        "lngm"  => lngm,
        "lngs"  => lngs,
        "lngh"  => lngh,
        "lng"   => lng,
      }
    end
  end
end
