# WizardVan: A Sensu Metrics Relay

[![Coverage Status](https://coveralls.io/repos/opower/sensu-metrics-relay/badge.png?branch=master)](https://coveralls.io/r/opower/sensu-metrics-relay?branch=master) [![Build Status](https://travis-ci.org/opower/sensu-metrics-relay.png?branch=master)](https://travis-ci.org/opower/sensu-metrics-relay)


WizardVan uses a combination of a handler and a metric extension to open
persistent TCP connections between the Sensu servers and back-end metric store
for firehose relaying of metrics events from Sensu to metric stores.

Handler extensions are useful in firehose situations.  You could easily write a
handler plug-in to do this, but an extension would be significantly less
resource intensive. Were a simple firehose implemented in a plug-in, every
event would cause a fork of the parent ruby process and writing data over a TCP
(more likely) or UDP connection.

An extension, on the other hand, could maintain persistent TCP connections to
the firehose destination and simply write serialized event data over that
connection. In high-volume metrics installations, 10-100k metrics per minute or
more, this kind of optimization is a requirement.

It also includes some mutation functionality to mutate from Graphite
to OpenTSDB as well as accepts a new metric format for submitting metrics
in JSON and mutating from that to any number of configured metric
backends. To implement a mutator you simply need to define the endpoint
in the relay configuration and then define a mutator in metrics.rb.

**NOTE**: If you are pushing metrics in a format other than Graphite, you will
have to to add "output\_type": "opentsdb" or "json" to your check definitions.

## Installation

As root:

1. cp -R lib/sensu/extensions/\* /etc/sensu/extensions
2. cp config\_relay.json /etc/sensu/conf.d
3. Edit the values in config\_relay.json according to your environment.
4. Restart sensu-server

Relay currently supports "graphite" and "opentsdb" as metric back-ends.

## Configuration

config\_relay.json:

```json
{
  "relay": {
    "graphite": {
        "host": "127.0.0.1",
        "port": 60000,
        "max_queue_size": 16384 # optional
    },
    "opentsdb": {
        "host": "127.0.0.1",
        "port": 4424
    }
  }
}
```

The metrics relay uses the plaintext protocol for Graphite and OpenTSDB's RPC protocol
for transmitting metrics. Be sure to configure accordingly.

The behavior of the mutator and handler is heavily influenced by several configuration
options. The mutator introduces the concept of "output_type". By default, the extension
assumes an "output_type" of "graphite." If your metrics are outputting anything besides
graphite-formatted metrics, you will need to specify an "output_type" in your metrics
checks that corresponds to a configured relay endpoint.

In the example check below, you will also see the "auto_tag_host" configuration variable.
Most metrics will be associated with a particular host, so this will default to yes.

You must also specify "relay" as your handler.

For example, if you have a metric check that outputs opentsdb:

```json
"checks": {
    "my_check": {
        "name": "opentsdb_metric",
        "output_type": "opentsdb",
        "auto_tag_host": "yes",
        "type": "metric",
        "handlers": [ "relay" ],
        "command": "/path/to/opentsdb_metric.rb"
    }
}
```

You would then configure "opentsdb" as an endpoint in relay.

In the configuration example above, you will notice that we define graphite and opentsdb
back-ends. The relay currently includes functionality to mutate between graphite and opentsdb.
So, if you are submitting graphite metrics and define an opentsdb backend in config_relay.json,
then it will automatically mutate from graphite to opentsdb and submit metrics to opentsdb.

## JSON Metric format

The relay currently only supports graphite and opentsdb as endpoints for
mutation from JSON. The JSON format for metrics is as follows:

```json
{
    "name": "metric_name",
    "value": 1,
    # optional epoch time stamp, precision can be higher, but graphite will floor()
    # and does not aggregate metrics, currently.
    "timestamp": 1365624303
    "tags": {
      "service": "some_service", # optional
      "some_tag": "some_value" # optional
    }
}
```

## Development

### Running the test suite

To run tests continuously with guard, do:

```
bundle exec guard
```

Guard will start up a foreground process that runs the relevant specs every
time you save a file and runs all the (non-slow) specs if you hit enter.  For
fancier interactions and configuration information, see the [guard
documentation](https://github.com/guard/guard) and the [guard-rspec
documentation](https://github.com/guard/guard-rspec).

To run the full suite (this takes up to 10 minutes), do:

```
bundle exec rspec
```

For information on contributing, please see CONTRIBUTING.md
