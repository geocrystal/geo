# Geo::Coord

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

## Contributing

1. Fork it (<https://github.com/mamantoha/geo_coord/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
