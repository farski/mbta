# Mbta

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'mbta'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mbta

## Usage

Basic example:

json = HTTParty.get('http://developer.mbta.com/Data/Red.json')
MBTA::HeavyRail::System::MAP.lines['Red'].parse_announcements(json)

p MBTA::RedLine['Harvard'][:northbound].predictions.first.time


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
