# Geo

[![Build Status](https://travis-ci.org/geocrystal/geo.svg?branch=master)](https://travis-ci.org/geocrystal/geo)
[![GitHub release](https://img.shields.io/github/release/geocrystal/geo.svg)](https://github.com/geocrystal/geo/releases)
[![License](https://img.shields.io/github/license/geocrystal/geo.svg)](https://github.com/geocrystal/geo/blob/master/LICENSE)

Geospatial primitives, algorithms, and utilities for Crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     geo:
       github: geocrystal/geo
   ```

2. Run `shards install`

## Usage

```crystal
require "geo"

c = Geo::Coord.new(50.004444, 36.231389)

c.to_s
# => 50°0'16"N 36°13'53"E

c.to_s(dms: false)
# => 50.004444,36.231389

c.strfcoord(%{%latd %latm' %0.1lats" %lath, %lngd %lngm' %0.1lngs" %lngh})
# => 50 0' 16.0" N, 36 13' 53.0" E
```

### Formatting

`Geo::Coord#strfcoord` formats coordinates according to directives.

Each directive starts with `%` and can contain some modifiers before its name.

Acceptable modifiers:

- unsigned integers: none;
- signed integers: `+` for mandatory sign printing;
- floats: same as integers and number of digits modifier, like `0.3`.

List of directives:

| Directive | Description
| --------- | ------------------------------------------- |
| `%lat`    | Full latitude, floating point, signed       |
| `%latds`  | Latitude degrees, integer, signed           |
| `%latd`   | Latitude degrees, integer, unsigned         |
| `%latm`   | Latitude minutes, integer, unsigned         |
| `%lats`   | Latitude seconds, floating point, unsigned  |
| `%lath`   | Latitude hemisphere, "N" or "S"             |
| `%lng`    | Full longitude, floating point, signed      |
| `%lngds`  | Longitude degrees, integer, signed          |
| `%lngd`   | Longitude degrees, integer, unsigned        |
| `%lngm`   | Longitude minutes, integer, unsigned        |
| `lngs`    | Longitude seconds, floating point, unsigned |
| `%lngh`   | Longitude hemisphere, "E" or "W"            |

Examples:

```crystal
g = Geo::Coord.new(50.004444, 36.231389)
g.strfcoord('%+lat, %+lng')
# => "+50.004444, +36.231389"
g.strfcoord("%latd°%latm'%lath -- %lngd°%lngm'%lngh")
# => "50°0'N -- 36°13'E"
```

`strfcoord` handles seconds rounding implicitly:

```crystal
pos = Geo::Coord.new(0.033333, 91.333333)
pos.strfcoord('%latd %latm %0.5lats') # => "0 1 59.99880"
pos.strfcoord('%latd %latm %lats')  # => "0 2 0"
```

### Calculate distances between two coords

Haversine formula from [haversine](https://github.com/geocrystal/haversine) shard is used.

```crystal
require "geo"
require "geo/distance"

london = Geo::Coord.new(51.500153, -0.126236)
new_york = Geo::Coord.new(40.714268, -74.005974)

new_york.distance(london).to_kilometers
# => 5570.4744596620685
```

## Contributing

1. Fork it (<https://github.com/geocrystal/geo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
