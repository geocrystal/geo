# Geo::Coord

[![Build Status](https://travis-ci.org/mamantoha/geo_coord.svg?branch=master)](https://travis-ci.org/mamantoha/geo_coord)
[![GitHub release](https://img.shields.io/github/release/mamantoha/geo_coord.svg)](https://github.com/mamantoha/geo_coord/releases)
[![License](https://img.shields.io/github/license/mamantoha/geo_coord.svg)](https://github.com/mamantoha/geo_coord/blob/master/LICENSE)

Geo Coordinates class for Crystal, inspired by the Ruby's [geo_coord](https://github.com/zverok/geo_coord) gem.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     geo_coord:
       github: mamantoha/geo_coord
   ```

2. Run `shards install`

## Usage

```crystal
require "geo_coord"

c = Geo::Coord.new(50.004444, 36.231389)

c.to_s
# => "50°0'16\"N 36°13'53\"E"

c.to_s(dms: false)
# => "50.004444,36.231389"

c.strfcoord(%{%latd %latm' %lats" %lath, %lngd %lngm' %lngs" %lngh})
# => "50°0'16\"N 36°13'53\"E"
```

### Calculate distances between two coords

Haversine formula from [haversine](https://github.com/mamantoha/haversine) shard is used.

```crystal
require "geo_coord"
require "geo_coord/distance"

london = Geo::Coord.new(51.500153, -0.126236)
new_york = Geo::Coord.new(40.714268, -74.005974)

new_york.distance(london).to_kilometers
# => 5570.4744596620685
```

## Contributing

1. Fork it (<https://github.com/mamantoha/geo_coord/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
