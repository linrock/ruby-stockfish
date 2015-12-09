gem 'minitest'
require 'minitest/autorun'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'stockfish'


def read_fixture(path)
  open("#{File.dirname(__FILE__)}/fixtures/#{path}").read
end
