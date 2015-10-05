# Nwsdk

Simplified wrapper + cli for NetWitness REST endpoints

[![Build Status](https://travis-ci.org/ryanbreed/nwsdk.svg?branch=master)](https://travis-ci.org/ryanbreed/nwsdk)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nwsdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nwsdk

## Usage
Module documentation is non-existent. Best bet is to look at the specs and/or the cli
driver invocations.

To get up and running, invoke 'nw config' and edit ~/.nwsdk.json

The cli is mainly used from the nw command:

    Commands:
      nw cef CONDITIONS --loghost=LOGHOST            # send cef alerts for query conditions
      nw configure [$HOME/.nwsdk.json]               # write out a template configuration file
      nw content CONDITIONS                          # extract files for given query conditions
      nw help [COMMAND]                              # Describe available commands or one specific command
      nw pcap CONDITIONS                             # extract PCAP for given query conditions
      nw query CONDITIONS                            # execute SDK query
      nw timeline CONDITIONS                         # get a time-indexed histogram for conditions
      nw values CONDITIONS                           # get value report for specific meta key

    Options:
      [--config=CONFIG]  # JSON file with endpoint info & credentials
                         # Default: $HOME/.nwsdk.json
      [--host=HOST]      # hostname for broker or concentrator
      [--port=N]         # REST port for broker/concentrator
                         # Default: 50103
      [--span=N]         # max timespan in seconds
                         # Default: 3600
      [--limit=N]        # max number of sessions
                         # Default: 10000
      [--start=START]    # start time for query
                         # Default: $now-1h
      [--end=END]        # end time for query
                         # Default: $now-ish



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ryanbreed/nwsdk.

Any fixtures/mocks/etc for the actual REST traffic would be highly welcome additions.

## License

GPLv3 (see LICENSE)
