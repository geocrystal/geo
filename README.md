# Geo

![Crystal CI](https://github.com/geocrystal/geo/workflows/Crystal%20CI/badge.svg)
[![GitHub release](https://img.shields.io/github/release/geocrystal/geo.svg)](https://github.com/geocrystal/geo/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://geocrystal.github.io/geo/)
[![License](https://img.shields.io/github/license/geocrystal/geo.svg)](https://github.com/geocrystal/geo/blob/master/LICENSE)

Geospatial primitives, algorithms, and utilities for Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  geo:
    github: geocrystal/geo
```

Run `shards install`

## Usage

A `Geo::Coord` is a point in geographical coordinates: latitude and longitude.

```crystal
require "geo"

c = Geo::Coord.new(50.004444, 36.231389)

c.strfcoord(%{%latd %latm' %0.1lats" %lath, %lngd %lngm' %0.1lngs" %lngh})
# => 50 0' 16.0" N, 36 13' 53.0" E

c.strfcoord("%lat,%lng")
# => "-50.004444,-36.231389"

c.to_s
# => 50°0'16"N 36°13'53"E
```

### Polygon

A polygon represents an area enclosed by a closed path (or loop), which is defined by a series of coordinates.

```crystal
require "geo"

pos1 = Geo::Coord.new(45.3142533036254, -93.47527313511819)
pos2 = Geo::Coord.new(45.31232182518015, -93.34893036168069)
pos3 = Geo::Coord.new(45.23694281999268, -93.35167694371194)
pos4 = Geo::Coord.new(45.23500870841669, -93.47801971714944)

polygon = Geo::Polygon.new([pos1, pos2, pos3, pos4])
```

The Polygon in the example above consists of four sets of `Geo::Coord` coordinates, but notice that the first and last sets define the same location, which completes the loop. In practice, however, since polygons define closed areas, you don't need to specify the last set of coordinates. Ot will automatically complete the polygon by connecting the last location back to the first location.

The following example is identical to the previous one, except that the last `Geo::Coord` is omitted:

```crystal
require "geo"

pos1 = Geo::Coord.new(45.3142533036254, -93.47527313511819)
pos2 = Geo::Coord.new(45.31232182518015, -93.34893036168069)
pos3 = Geo::Coord.new(45.23694281999268, -93.35167694371194)

polygon = Geo::Polygon.new([pos1, pos2, pos3])
```

Additional actions:

```crystal
coord_inside = Geo::Coord.new(45.27428243796789, -93.41648483416066)
coord_outside = Geo::Coord.new(45.45411010558687, -93.78151703160256)

polygon.contains?(coord_inside)  # => true
polygon.contains?(coord_outside) # => false

polygon.centroid # => Geo::Coord(@lat=45.27463866133501, @lng=-93.41400121829719)
```

Additionally you can initialize polygon as [convex hull](https://en.wikipedia.org/wiki/Convex_hull) from coordinates of points.

```crystal
points = [
  {1.0, 1.0},
  {1.0, 0.0},
  {1.0, -1.0},
  {0.0, -1.0},
  {-1.0, -1.0},
  {-1.0, 0.0},
  {-1.0, 1.0},
  {0.0, 1.0},
  {0.0, 0.0},
].map { |point| Geo::Coord.new(point[0], point[1]) }

polygon = Geo::Polygon.new(points, convex_hull: true)
polygon.coords
# => {-1.0, -1.0}, {1.0, -1.0}, {1.0, 1.0}, {-1.0, 1.0}, {-1.0, -1.0}
```

The convex hull is computed using the [convex_hull](github.com/geocrystal/convex_hull) library.

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
