require 'coveralls'
require 'simplecov'

$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require File.expand_path('../helpers.rb', __FILE__)
require File.expand_path('../fixtures.rb', __FILE__)

include Wizardvan::Test::Helpers

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
SimpleCov.start
