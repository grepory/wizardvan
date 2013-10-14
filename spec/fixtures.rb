require 'json'

def load_json(fixture, symbolize = true)
  JSON.parse(File.read(fixture), symbolize_names: symbolize)
end

def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

module Wizardvan::Test
  module Fixtures

    BAD_GRAPHITE_EVENT = load_json(fixture('events/bad_graphite.json'))
    GRAPHITE_EVENT = load_json(fixture('events/graphite.json'))
    EMPTY_EVENT = load_json(fixture('events/empty.json'))
    OPENTSDB_EVENT = load_json(fixture('events/opentsdb.json'))
    JSON_EVENT = load_json(fixture('events/json.json'))
    JSON_EVENT_WITH_NAME = load_json(fixture('events/json_withname.json'))
    SETTINGS_FILE = fixture('settings.json')
    SETTINGS = load_json(SETTINGS_FILE)
    SETTINGS_BAD = load_json(fixture('settings_bad.json'))
    MUTATED_EVENT = load_json(fixture('events/mutated.json'))
    HOST = '127.0.0.1'
    PORT = 31337

  end
end
